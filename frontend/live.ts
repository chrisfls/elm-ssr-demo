import { ConnInfo, serve } from "std/http/server.ts";
import { serveDir, serveFile } from "std/http/file_server.ts";
import * as fs from "std/fs/mod.ts";

import { refresh } from "refresh/mod.ts";

import { createHandler } from "./server.ts";
import { load } from "./elm.ts";
import { make, replacements } from "./make.ts";

const publicDir = "public";
const reload = "reload.js";

const tmp = async () => `${await Deno.makeTempFile()}.js`;
const client = await tmp();
const server = await tmp();

const refresher = refresh({
  paths: [
    "./src",
    "./server/src",
    "./public",
  ],
});

const ssr = await createHandler({
  publicDir,
  server,
  client: "bundle.js",
  extra: reload,
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
    await make("src/Main.elm", client, {
      debug: true,
    });

    return serveFile(request, client);
  }

  await make("src/Server/Main.elm", server, {
    cwd: "./server",
    debug: true,
    deno: true,
    replace: [
      replacements.serverHtmlToJson,
      replacements.serverMessageToJson,
    ],
  });

  await load(server);

  return await ssr(request, connInfo);
}

await serve(handler);
