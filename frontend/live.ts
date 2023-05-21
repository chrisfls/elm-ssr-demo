import { ConnInfo, serve } from "std/http/server.ts";
import { serveDir, serveFile } from "std/http/file_server.ts";

import { script } from "./hotswap.ts";
import { createHandler } from "./server.ts";
import { make } from "./elm.ts";
import { refresh } from "refresh/mod.ts";

const publicDir = "public";

const tmp = async () => `${await Deno.makeTempFile()}.js`;
const client = await tmp();
const server = await tmp();

const hotswap = refresh();

const ssr = await createHandler({
  publicDir,
  server,
  inject: script,
  client: "bundle.js",
});

async function handler(
  request: Request,
  connInfo: ConnInfo,
): Promise<Response> {
  const response = hotswap(request);
  if (response) return response;

  const url = new URL(request.url);

  if (url.pathname === "/favicon.ico") {
    return serveDir(request, { fsRoot: publicDir });
  }

  if (url.pathname === `/${script}`) {
    return serveFile(request, script);
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
