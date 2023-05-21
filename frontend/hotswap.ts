import * as fs from "std/fs/mod.ts";

export const script = "hotswap.js";

if (!await fs.exists(script)) {
  const json = await Deno.readTextFile("./deno.jsonc");
  const deno: { imports: Record<string, string> } = eval(`(${json})`);
  const ns = deno.imports["refresh/"];
  if (ns === undefined) throw new Error("No import map found for 'refresh/'.");

  const response = await fetch(`${ns}client.js`);
  const content = await response.text();

  await Deno.writeTextFile(script, content);
}
