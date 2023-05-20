import { serve } from "std/http/server.ts";

import { routes } from "./routes.ts";

export async function handler(request: Request): Promise<Response> {
  for (const route of routes) {
    const match = route.pattern.exec(request.url);
    if (match === null) continue;
    return await route.handler(match, request);
  }

  return new Response(null, { status: 404 });
}

if (import.meta.main) {
  serve(handler);
}
