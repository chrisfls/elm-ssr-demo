import { Deferred, deferred } from "std/async/deferred.ts";
import { Handler, serve } from "std/http/server.ts";
import * as path from "std/path/mod.ts";

import * as eta from "eta";

import * as elm from "./elm.ts";

export interface Options {
  /** Path for public assets. */
  publicDir?: string;

  /** Path to server js. */
  server?: string;

  /** Path to client js. */
  client?: string;

  /** Timeout for rendering. */
  timeout?: number;

  /** Extra script to inject (used by hotswap) */
  extra?: string;
}

async function find(
  directory: string,
): Promise<string | undefined> {
  let highest = 0;
  let filename: string | undefined;

  for await (const entry of Deno.readDir(directory)) {
    if (!entry.isFile) continue;

    const matches = entry.name.match(/^bundle\.(\d+)\.js$/);
    if (matches == null) continue;

    const match = matches[1];
    if (match === undefined) continue;

    const timestamp = parseInt(match);

    if (timestamp > highest) {
      highest = timestamp;
      filename = entry.name;
    }
  }

  if (filename) return path.join(directory, filename);
}

class Defer<T> {
  #index = 0;
  #promises = new Map<number, Deferred<T>>();

  constructor() {}

  get() {
    const id = ++this.#index;
    const promise = deferred<T>();
    this.#promises.set(id, promise);
    return { id, promise };
  }

  resolve(id: number, message: T) {
    const promise = this.#promises.get(id);
    this.#promises.delete(id);
    promise?.resolve(message);
  }

  reject(id: number, reason: unknown) {
    const promise = this.#promises.get(id);
    this.#promises.delete(id);
    promise?.reject(reason);
  }
}

function encode(requestHeaders: Headers): elm.HttpPort["headers"] {
  const headers: elm.HttpPort["headers"] = {};

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

export async function createHandler(options?: Options): Promise<Handler> {
  const publicDir = options?.publicDir ?? "public";
  const server = options?.server ?? "ssr.js";
  const client = options?.client ?? await find(publicDir);
  const timeout = options?.timeout ?? 10000;
  const extra = options?.extra;

  if (client === undefined) {
    throw new Error("Unable to find the client build");
  }

  const config = eta.configure({ views: Deno.cwd() });
  const defer = new Defer<elm.HtmlPort>();

  let app: elm.App | undefined;

  return async function handler(request) {
    if (app === undefined) {
      app = (await elm.load(server)).Main.init({ flags: {} });
      app.ports.htmlPort.subscribe((msg) => defer.resolve(msg.id, msg));
      app.ports.loggerPort.subscribe(
        ({ level, message }) => console[level](message),
      );
    }

    const { id, promise } = defer.get();

    const timer = setTimeout(() => {
      if (app) app.ports.cancelPort.send({ id });
      defer.reject(id, new Error("Server-side rendering timed out"));
    }, timeout);

    const url = new URL(request.url);

    app.ports.httpPort.send({
      id,
      url: url.toString(),
      headers: encode(request.headers),
    });

    const { view, model } = await promise;

    clearTimeout(timer);

    return new Response(
      await eta.renderFileAsync("index", {
        extra,
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
