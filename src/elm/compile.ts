import * as elm from "node-elm-compiler";

type Options = {
  debug: boolean;
  optimize: boolean;
  cwd: string
};

export async function compileString(
  input: string,
  output: string,
  options?: Partial<Options>,
): Promise<string> {
  return (await elm.compileToString(
    [input],
    {
      output,
      pathToElm: "./node_modules/.bin/elm",
      cwd: options?.cwd ?? Deno.cwd(),
      debug: options?.debug ?? true,
      optimize: options?.optimize ?? false,
      verbose: true,
    },
  )).replace(/\(this\)\)\;$/g, "(globalThis));");
}

export async function compileFile(
  input: string,
  output: string,
  options?: Partial<Options>,
): Promise<void> {
  Deno.writeTextFileSync(
    output,
    await compileString(input, output, options),
  );
}
