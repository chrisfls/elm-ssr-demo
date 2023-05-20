import * as path from "std/path/mod.ts";

import { Elm, Ports } from "./app.ts";

export async function load<P extends Ports = Ports>(
  filePath: string,
): Promise<Elm<P>> {
  await import(path.join(Deno.cwd(), filePath));
  // deno-lint-ignore no-explicit-any
  return (globalThis as unknown as { Elm: Elm<any> })["Elm"];
}
