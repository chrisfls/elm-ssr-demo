import { contentType } from "std/media_types/content_type.ts";
import * as path from "std/path/mod.ts";
import * as fs from "std/fs/mod.ts";
import { Deferred, deferred } from "std/async/deferred.ts";

import * as eta from "eta";

import * as elm from "./elm/mod.ts";
import { findLastBundle } from "./elm/bundle.ts";
import * as env from "./env.ts";
import * as response from "./response/mod.ts";

const SERVER_ELM = "web/bundle.js";
const CLIENT_ELM = env.development ? "bundle.js" : await findLastBundle();

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

if (!await fs.exists(SERVER_ELM)) {
  throw new Error(`'${SERVER_ELM}' not found.`);
}

if (CLIENT_ELM === undefined) {
  throw new Error("CLIENT_ELM is undefined");
}

eta.configure({
  views: path.join(Deno.cwd(), "web"),
});

async function getApp() {
  return (await elm.load<Ports>(SERVER_ELM)).Main.init({});
}

let app = await getApp();
let count = 0;

const pending = new Map<number, Deferred<string>>();

function subscription({ id, html }: HtmlMsg) {
  pending.get(id)?.resolve(html);
  pending.delete(id);
}

export async function router(_req: Request, url: URL): Promise<Response> {
  if (env.development) {
    await elm.compileFile("app/server/Main.elm", SERVER_ELM);
    app.ports.html.unsubscribe(subscription);
    app = await getApp();
    app.ports.html.subscribe(subscription);
  }

  const id = count++;
  const promise = deferred<string>();

  pending.set(id, promise);

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
