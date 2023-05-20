import { serve } from "std/http/server.ts";
import { serveDir } from "std/http/file_server.ts";

import * as elm from "./elm/mod.ts";
import * as env from "./env.ts";
import { router } from "./router.ts";

const STATIC_DIR = "static";
const STATIC_URL = `/${STATIC_DIR}/`;

export async function handler(request: Request): Promise<Response> {
  const url = new URL(request.url);

  if (url.pathname.startsWith(STATIC_URL)) {
    return serveDir(request, { fsRoot: STATIC_DIR, urlRoot: STATIC_DIR });
  }

  if (env.development && url.pathname === "/bundle.js") {
    return new Response(
      await elm.compileString("app/browser/Main.elm", "static/bundle.js"),
      {
        status: 200,
        headers: { "content-type": "application/javascript" },
      },
    );
  }

  return router(request, url);
}

if (import.meta.main) {
  serve(handler);
}
