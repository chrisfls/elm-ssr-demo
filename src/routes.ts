import { contentType } from "std/media_types/content_type.ts";
import * as path from "std/path/mod.ts";
import * as fs from "std/fs/mod.ts";
import { deferred } from "std/async/deferred.ts";

import * as Eta from "eta";

import * as elm from "./elm/mod.ts";
import { findLastBundle } from "./elm/bundle.ts";
import * as env from "./env.ts";
import * as response from "./response/mod.ts";

Eta.configure({
  views: path.join(Deno.cwd(), "web"),
});

type Route = {
  pattern: URLPattern;
  handler: (
    pattern: URLPatternResult,
    request: Request,
  ) => Response | Promise<Response>;
};

const SERVER_ELM = "web/index.js";
const CLIENT_ELM = env.development ? "index.js" : await findLastBundle();

const debug = env.development
  ? (route: Route) => [route]
  : (_route: Route) => [];

if (CLIENT_ELM === undefined) {
  throw new Error("No elm app bundle found");
}

type Ports = {
  ssr: elm.PortWithSubscription<string>;
};

export const routes: Route[] = [
  {
    pattern: new URLPattern({ pathname: "/" }),
    async handler(): Promise<Response> {
      if (env.development) {
        elm.compile("app/server/Main.elm", SERVER_ELM);
      }

      if (!await fs.exists("web/index.js")) {
        return new Response(null, { status: 404 });
      }

      const app = (await elm.load<Ports>(SERVER_ELM)).Main.init({});
      const response = deferred<Response>();

      async function subscription(ssr: string) {
        app.ports.ssr.unsubscribe(subscription);

        response.resolve(
          new Response(
            await Eta.renderFileAsync("index", { bundle: CLIENT_ELM, ssr }),
            {
              status: 200,
              headers: { "content-type": "text/html" },
            },
          ),
        );
      }

      app.ports.ssr.subscribe(subscription);

      return await response;
    },
  },
  ...debug({
    pattern: new URLPattern({ pathname: "/index.js" }),
    async handler(): Promise<Response> {
      elm.compile("app/browser/Main.elm", "public/index.js");
      return await response.fileStream(
        "public/index.js",
        "application/javascript; charset=UTF-8",
      );
    },
  }),
  {
    pattern: new URLPattern({ pathname: "/assets/:file" }),
    async handler(pattern): Promise<Response> {
      const filePath = path.join("web", pattern.pathname.groups.file);
      return await response.fileStream(
        filePath,
        contentType(path.extname(pattern.pathname.groups.file)),
      );
    },
  },
];
