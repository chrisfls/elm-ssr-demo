import { Handler, serve } from "std/http/server.ts";
import * as path from "std/path/mod.ts";
import { Deferred, deferred } from "std/async/deferred.ts";

import * as eta from "eta";

import { HtmlPort, HttpPort, load } from "./app.ts";
import { find } from "./client.ts";

export interface Options {
  web?: string;
  publicDir?: string;
  server?: string;
  client?: string;
  timeout?: number;
}

function parseHeaders(requestHeaders: Headers): HttpPort["headers"] {
  const headers: HttpPort["headers"] = {};

  requestHeaders.forEach((value, key) => {
    const array = headers[key];
    if (array === undefined) {
      headers[key] = [value];
    } else {
      array.push(value);
    }
  });

  return headers;
}

function createRegistry() {
  let index = 0;
  const promises = new Map<number, Deferred<string>>();

  return {
    resolve({ id, html }: HtmlPort) {
      promises.get(id)?.resolve(html);
      promises.delete(id);
    },
    defer() {
      const id = ++index;
      const defer = deferred<string>();

      promises.set(id, defer);

      return {
        id,
        defer,
        abort(reason?: unknown) {
          promises.delete(id);
          defer.reject(reason);
        },
      };
    },
  };
}

export async function createHandler(options?: Options): Promise<Handler> {
  const web = options?.web ?? ".";
  const publicDir = options?.publicDir ?? "public";
  const server = options?.server ?? "ssr.js";
  const client = options?.client ?? await find(publicDir);
  const timeout = options?.timeout ?? 10000;
  const config = eta.configure({
    views: path.join(Deno.cwd(), web),
  });

  if (client === undefined) {
    throw new Error("client is undefined");
  }

  const app = (await load(server)).Main.init({ flags: {} });
  const registry = createRegistry();

  app.ports.html.subscribe(registry.resolve);

  return async function handler(request) {
    const url = new URL(request.url);
    const { id, defer, abort } = registry.defer();

    app.ports.http.send({
      id,
      url: url.toString(),
      headers: parseHeaders(request.headers),
    });

    const timer = setTimeout(
      () => {
        app.ports.timeout.send({ id });
        abort(new Error("Operation timed out"));
      },
      timeout,
    );

    const html = await defer;

    clearTimeout(timer);

    return new Response(
      await eta.renderFileAsync("index", { client, html }, config),
      {
        status: 200,
        headers: { "content-type": "text/html" },
      },
    );
  };
}

if (import.meta.main) {
  serve(await createHandler());
}
