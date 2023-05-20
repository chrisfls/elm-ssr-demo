import * as env from "../src/env.ts";
import { compile } from "../src/elm/compile.ts";

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
