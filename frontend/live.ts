import { ConnInfo, serve } from "std/http/server.ts";
import { serveDir, serveFile } from "std/http/file_server.ts";
import * as fs from "std/fs/mod.ts";

import { refresh } from "refresh/mod.ts";
import { xelm } from "../../expanded-elm/xelm.ts";

import { createHandler } from "./server.ts";
import { replacements } from "./make.ts";

const publicDir = "public";
const reload = "reload.js";

const client = `${await Deno.makeTempFile()}.js`;
const server = `${await Deno.makeTempFile()}.mjs`;

const refresher = refresh({
  paths: [
    "./src",
    "./server/src",
    "./public",
  ],
});

if (!await fs.exists(reload)) {
  const json = await Deno.readTextFile("./deno.jsonc");
  const deno: { imports: Record<string, string> } = eval(`(${json})`);
  const ns = deno.imports["refresh/"];
  if (ns === undefined) throw new Error("No import map found for 'refresh/'.");

  const response = await fetch(`${ns}client.js`);
  const content = await response.text();

  await Deno.writeTextFile(reload, content);
}

async function handler(
  request: Request,
  connInfo: ConnInfo,
): Promise<Response> {
  const response = refresher(request);
  if (response) return response;

  const url = new URL(request.url);

  if (url.pathname === "/favicon.ico") {
    return serveDir(request, { fsRoot: publicDir });
  }

  if (url.pathname === `/${reload}`) {
    return serveFile(request, reload);
  }

  if (url.pathname.startsWith(`/${publicDir}/`)) {
    return serveDir(request, { fsRoot: publicDir, urlRoot: publicDir });
  }

  if (url.pathname === "/bundle.js") {
    //   await xelm(["src/Main.elm"], client, {
    //     debug: true,
    //   });

    return serveFile(request, client);
  }

  await xelm(["src/Server/Main.elm"], server, {
    projectRoot: "./server",
    debug: true,
    typescript: "deno",
    transformations: [replacements.serverHtmlToJson],
  });

  const abort = new AbortController();

  const htmlResponse = await (await createHandler({
    publicDir,
    server,
    client: "bundle.js",
    extra: reload,
    signal: abort.signal,
  }))(request, connInfo);

  abort.abort();

  return htmlResponse;
}

await serve(handler);
