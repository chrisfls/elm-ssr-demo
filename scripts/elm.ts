import * as path from "std/path/mod.ts";
import * as flags from "std/flags/mod.ts";

import * as env from "../src/env.ts";
import { compileFile } from "../src/elm/compile.ts";

const args: {
  in?: string;
  out?: string;
  "no-timestamp"?: boolean;
} = flags.parse(Deno.args);

const input = args.in;
const output = args.out;
const timestamp = !args["no-timestamp"];

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

function pathWithTimestamp(output: string) {
  const parsed = path.parse(output);
  return path.format({
    ...parsed,
    base: `${parsed.name}.${Date.now()}${parsed.ext}`,
  });
}

compileFile(
  input,
  timestamp && !env.development ? pathWithTimestamp(output) : output,
  {
    debug: env.development,
    optimize: !env.development,
  },
);
