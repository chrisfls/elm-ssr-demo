import { Handler, serve } from "std/http/server.ts";
import * as path from "std/path/mod.ts";
import { Deferred, deferred } from "std/async/deferred.ts";

import * as eta from "eta";

import { App, ErrorPort, HtmlPort, HttpPort, load } from "./app.ts";
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
    error({ id, reason }: ErrorPort) {
      promises.get(id)?.reject({
        type: "error",
        reason,
      });
      promises.delete(id);
    },
    resolve({ id, value }: HtmlPort) {
      promises.get(id)?.resolve(value);
      promises.delete(id);
    },
    defer(app: App) {
      const id = ++index;
      const defer = deferred<string>();

      promises.set(id, defer);

      return {
        id,
        defer,
        timeout() {
          app.ports.timeoutPort.send({ id });
          promises.delete(id);
          defer.reject({ type: "timeout" });
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

  app.ports.htmlPort.subscribe(registry.resolve);
  app.ports.errorPort.subscribe(registry.error);

  return async function handler(request) {
    const url = new URL(request.url);
    const { id, defer, timeout: cancel } = registry.defer(app);

    app.ports.httpPort.send({
      id,
      url: url.toString(),
      headers: parseHeaders(request.headers),
    });

    const timer = setTimeout(cancel, timeout);
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
