import { serve } from "std/http/server.ts";
import { serveDir } from "std/http/file_server.ts";

import * as elm from "./elm/mod.ts";
import * as env from "./env.ts";

export async function handler(request: Request): Promise<Response> {
  const pathname = new URL(request.url).pathname;

  if (pathname.startsWith("/static")) {
    return serveDir(request, { fsRoot: "public", urlRoot: "static" });
  }

  if (env.development && pathname === "bundle.js") {
    return new Response(
      await elm.compileString("app/browser/Main.elm", "public/bundle.js"),
      {
        status: 200,
        headers: { "content-type": "application/javascript" },
      },
    );
  }

  // for (const route of routes) {
  //   const match = route.pattern.exec(request.url);
  //   if (match === null) continue;
  //   return await route.handler(match, request);
  // }

  return await new Response(null, { status: 404 });
}

if (import.meta.main) {
  serve(handler);
}
