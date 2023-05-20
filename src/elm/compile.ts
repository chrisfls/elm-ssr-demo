import * as elm from "node-elm-compiler";

type Options = {
  debug: boolean;
  optimize: boolean;
};

export function compile(
  input: string,
  output: string,
  options?: Partial<Options>,
) {
  Deno.writeTextFileSync(
    output,
    elm.compileToStringSync(
      [input],
      {
        output,
        pathToElm: "./node_modules/.bin/elm",
        cwd: Deno.cwd(),
        debug: options?.debug ?? true,
        optimize: options?.optimize ?? false,
        verbose: true,
      },
    ).replace(/\(this\)\)\;$/g, "(globalThis));"),
  );
}
