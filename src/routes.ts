import { contentType } from "std/media_types/content_type.ts";
import * as path from "std/path/mod.ts";

import * as Eta from "eta";

import * as response from "./response/mod.ts";
import * as elm from "./elm/compile.ts";

Eta.configure({
  views: path.join(Deno.cwd(), "web"),
});

type Route = {
  debug?: true;
  pattern: URLPattern;
  handler: (
    pattern: URLPatternResult,
    request: Request,
  ) => Response | Promise<Response>;
};

export const routes: Route[] = [
  {
    pattern: new URLPattern({ pathname: "/" }),
    handler(_req, _pattern): Response {
      Eta.renderFileAsync("index", {});
      return new Response("A");
    },
  },
  {
    debug: true,
    pattern: new URLPattern({ pathname: "/index.js" }),
    async handler(_req, _pattern): Promise<Response> {
      elm.compile("app/browser/Main.elm", "public/index.js");
      return await response.fileStream(
        "public/index.js",
        "application/javascript; charset=UTF-8",
      );
    },
  },
  {
    pattern: new URLPattern({ pathname: "/assets/:file" }),
    async handler(_pattern): Promise<Response> {
      const filePath = path.join("web", _pattern.pathname.groups.file);
      return await response.fileStream(
        filePath,
        contentType(path.extname(_pattern.pathname.groups.file)),
      );
    },
  },
];
