import { Handler, serve } from "std/http/server.ts";

import { load } from "./app.ts";

export interface Options {
  client?: string;
  server?: string;
}

export async function createHandler(options?: Options): Promise<Handler> {
  const client = options?.client ?? "";
  const server = options?.server ?? "";

  await load(server);

  return function handler(_request) {
    return new Response("Hello, World!");
  };
}

if (import.meta.main) {
  serve(await createHandler());
}
