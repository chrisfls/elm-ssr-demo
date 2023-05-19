import * as elm from "node-elm-compiler";
import * as env from "./env.ts";

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

if (import.meta.main) {
  const input: string | undefined = Deno.args[0];
  const output: string | undefined = Deno.args[1];

  const isString = (value: unknown): value is string => {
    return typeof value === "string";
  };

  const isNonEmptyString = (value: unknown): value is string => {
    return isString(value) && value.trim() !== "";
  };

  const assertFilePath: (
    value: unknown,
    desc: { what: string; where: string },
  ) => asserts value is string = (value, { what, where }) => {
    if (!isNonEmptyString(value)) {
      console.error(
        `Please provide an ${what} file path as the ${where} argument.`,
      );
      Deno.exit(1);
    }
  };

  assertFilePath(input, { what: "input", where: "first" });
  assertFilePath(output, { what: "output", where: "second" });

  compile(input, output, {
    debug: env.development,
    optimize: !env.development,
  });
}
