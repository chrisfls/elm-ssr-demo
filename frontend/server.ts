import { Deferred, deferred } from "std/async/deferred.ts";
import { Handler, serve } from "std/http/server.ts";
import * as path from "std/path/mod.ts";

import * as eta from "eta";

import { App, ErrorPort, HtmlPort, HttpPort, load } from "./app.ts";

export interface Options {
  web?: string;
  publicDir?: string;
  server?: string;
  client?: string;
  inject?: string;
  timeout?: number;
}

const empty = [] as unknown as RegExpMatchArray[number];

async function find(
  directory: string,
): Promise<string | undefined> {
  let highest = 0;
  let filename: string | undefined;

  for await (const entry of Deno.readDir(directory)) {
    if (!entry.isFile) continue;
    const match = (entry.name.match(/^bundle\.(\d+)\.js$/) ?? empty)[1];
    if (match === undefined) continue;
    const timestamp = parseInt(match);
    if (timestamp > highest) {
      highest = timestamp;
      filename = entry.name;
    }
  }

  if (filename) return path.join(directory, filename);
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
  const promises = new Map<number, Deferred<HtmlPort>>();

  return {
    error({ id, reason }: ErrorPort) {
      promises.get(id)?.reject({
        type: "error",
        reason,
      });
      promises.delete(id);
    },
    render(message: HtmlPort) {
      promises.get(message.id)?.resolve(message);
      promises.delete(message.id);
    },
    defer(app: App) {
      const id = ++index;
      const defer = deferred<HtmlPort>();

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
  const inject = options?.inject;
  const config = eta.configure({
    views: path.join(Deno.cwd(), web),
  });

  if (client === undefined) {
    throw new Error("client is undefined");
  }

  const app = (await load(server)).Main.init({ flags: {} });
  const registry = createRegistry();

  app.ports.htmlPort.subscribe(registry.render);
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
    const { view, model } = await defer;

    clearTimeout(timer);

    return new Response(
      await eta.renderFileAsync("index", {
        inject,
        client,
        view,
        flags: JSON.stringify(model),
      }, config),
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
