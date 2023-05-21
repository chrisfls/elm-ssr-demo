import { ConnInfo, serve } from "std/http/server.ts";
import { serveDir, serveFile } from "std/http/file_server.ts";

import { make } from "./elm.ts";
import { createHandler } from "./server.ts";

const tmp = async () => `${await Deno.makeTempFile()}.js`;

const client = await tmp();
const server = await tmp();

await make("src/Main.elm", {
  cwd: "./client",
  debug: true,
  output: client,
});

await make("src/Main.elm", {
  cwd: "./server",
  debug: true,
  output: server,
  deno: true,
});

const publicDir = "public";
const publicUrl = "/public/";

const ssr = await createHandler({ publicDir, server, client: "bundle.js" });

async function handler(
  request: Request,
  connInfo: ConnInfo,
): Promise<Response> {
  const url = new URL(request.url);

  if (url.pathname === "/favicon.ico") {
    return serveDir(request, { fsRoot: publicDir });
  }

  if (url.pathname.startsWith(publicUrl)) {
    return serveDir(request, { fsRoot: publicDir, urlRoot: publicDir });
  }

  if (url.pathname === "/bundle.js") {
    return serveFile(request, client);
  }

  return await ssr(request, connInfo);
}

await serve(handler);
