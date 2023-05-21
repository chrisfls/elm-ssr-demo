import { Deferred, deferred } from "std/async/deferred.ts";
import { serve } from "std/http/server.ts";
import { serveDir } from "std/http/file_server.ts";
import * as fs from "std/fs/mod.ts";
import * as path from "std/path/mod.ts";

import * as eta from "eta";

import { findLastBundle } from "./elm/bundle.ts";
import * as elm from "./elm/mod.ts";
import * as env from "./env.ts";

type HttpMsg = {
  id: number;
  url: string;
};

type HtmlMsg = {
  id: number;
  html: string;
};

type Ports = {
  http: elm.PortWithSend<HttpMsg>;
  html: elm.PortWithSubscription<HtmlMsg>;
};

const PUBLIC_DIR = "public";
const PUBLIC_URL = `/${PUBLIC_DIR}/`;

const SERVER_ELM = "web/bundle.js";
const CLIENT_ELM = env.development
  ? "bundle.js"
  : await findLastBundle(PUBLIC_DIR);
const CLIENT_ROOT = path.join(Deno.cwd(), "app");

if (!await fs.exists(SERVER_ELM)) {
  throw new Error(`'${SERVER_ELM}' not found.`);
}

if (CLIENT_ELM === undefined) {
  throw new Error("CLIENT_ELM is undefined");
}

eta.configure({
  views: path.join(Deno.cwd(), "web"),
});

const app = (await elm.load<Ports>(SERVER_ELM)).Main.init({});
const promises = new Map<number, Deferred<string>>();

function subscription({ id, html }: HtmlMsg) {
  promises.get(id)?.resolve(html);
  promises.delete(id);
}

app.ports.html.subscribe(subscription);

let count = 0;

export async function handler(request: Request): Promise<Response> {
  const url = new URL(request.url);

  if (url.pathname === "/favicon.ico") {
    return serveDir(request, { fsRoot: PUBLIC_DIR });
  }

  if (url.pathname.startsWith(PUBLIC_URL)) {
    return serveDir(request, { fsRoot: PUBLIC_DIR, urlRoot: PUBLIC_DIR });
  }

  if (env.development && url.pathname === "/bundle.js") {
    return new Response(
      await elm.compileString("client/Main.elm", "../public/bundle.js", {
        cwd: CLIENT_ROOT,
      }),
      {
        status: 200,
        headers: { "content-type": "application/javascript" },
      },
    );
  }

  if (env.development) {
    await elm.compileFile("app/server/Main.elm", SERVER_ELM);
    await elm.load<Ports>(SERVER_ELM);
  }

  const id = ++count;
  const promise = deferred<string>();

  promises.set(id, promise);

  app.ports.http.send({ id, url: url.toString() });

  return new Response(
    await eta.renderFileAsync("index", {
      bundle: CLIENT_ELM,
      ssr: await promise,
    }),
    {
      status: 200,
      headers: { "content-type": "text/html" },
    },
  );
}

if (import.meta.main) {
  serve(handler);
}
