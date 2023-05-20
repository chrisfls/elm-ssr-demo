import { serve } from "std/http/server.ts";

import { routes } from "./routes.ts";
import * as env from "./env.ts";

export async function handler(request: Request): Promise<Response> {
  for (const route of routes) {
    if (route.debug && !env.development) continue;
    const match = route.pattern.exec(request.url);
    if (match === null) continue;
    return await route.handler(match, request);
  }

  return new Response(null, { status: 404 });
}

if (import.meta.main) {
  serve(handler);
}
