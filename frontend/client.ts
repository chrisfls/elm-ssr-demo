import * as path from "std/path/mod.ts";

const empty = [] as unknown as RegExpMatchArray[number];

export async function find(
  directory: string,
): Promise<string | undefined> {
  let highest = 0;
  let filename: string | undefined;

  for await (const entry of Deno.readDir(directory)) {
    if (!entry.isFile) continue;
    const match = (entry.name.match(/^bundle\.(\d+)\.js$/) ?? empty)[1];
    if (match === undefined) continue;
    const timestamp = parseInt(match);
    if (timestamp > highest) {
      highest = timestamp;
      filename = entry.name;
    }
  }

  if (filename) return path.join(directory, filename);
}
