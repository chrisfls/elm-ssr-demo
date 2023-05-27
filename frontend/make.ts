// deno-lint-ignore-file no-unused-vars no-explicit-any
import { xelm } from "../../expanded-elm/xelm.ts";

if (import.meta.main) {
  await xelm(["src/Main.elm"], `public/bundle.${Date.now()}.js`, {
    optimize: 1,
    minify: false,
  });

  await xelm(["src/Server/Main.elm"], "./bundle.mjs", {
    projectRoot: "./server",
    optimize: 3,
    typescript: "deno",
  });
}

const a = {} as any;
