import { ConnInfo, serve } from "std/http/server.ts";
import { serveDir, serveFile } from "std/http/file_server.ts";
import * as fs from "std/fs/mod.ts";

import { createHandler } from "./server.ts";
import { make } from "./elm.ts";
import { refresh } from "refresh/mod.ts";

const publicDir = "public";
const hotswap = "hotswap.js";

const tmp = async () => `${await Deno.makeTempFile()}.js`;
const client = await tmp();
const server = await tmp();

const live = refresh();

const ssr = await createHandler({
  publicDir,
  server,
  inject: hotswap,
  client: "bundle.js",
});

if (!await fs.exists(hotswap)) {
  const json = await Deno.readTextFile("./deno.jsonc");
  const deno: { imports: Record<string, string> } = eval(`(${json})`);
  const ns = deno.imports["refresh/"];
  if (ns === undefined) throw new Error("No import map found for 'refresh/'.");

  const response = await fetch(`${ns}client.js`);
  const content = await response.text();

  await Deno.writeTextFile(hotswap, content);
}

async function handler(
  request: Request,
  connInfo: ConnInfo,
): Promise<Response> {
  const response = live(request);
  if (response) return response;

  const url = new URL(request.url);

  if (url.pathname === "/favicon.ico") {
    return serveDir(request, { fsRoot: publicDir });
  }

  if (url.pathname === `/${hotswap}`) {
    return serveFile(request, hotswap);
  }

  if (url.pathname.startsWith(`/${publicDir}/`)) {
    return serveDir(request, { fsRoot: publicDir, urlRoot: publicDir });
  }

  if (url.pathname === "/bundle.js") {
    await make("src/Main.elm", {
      cwd: "./client",
      debug: true,
      output: client,
    });

    return serveFile(request, client);
  }

  await make("src/Main.elm", {
    cwd: "./server",
    debug: true,
    output: server,
    deno: true,
  });

  return await ssr(request, connInfo);
}

await serve(handler);
