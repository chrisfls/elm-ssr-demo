const empty = [] as unknown as RegExpMatchArray[number];

export async function findLastBundle(): Promise<string | undefined> {
  let highest = 0;
  let filename: string | undefined;

  for await (const entry of Deno.readDir("public")) {
    if (!entry.isFile) continue;
    const match = (entry.name.match(/^index\.(\d+)\.js$/) ?? empty)[1];
    if (match === undefined) continue;
    const timestamp = parseInt(match);
    if (timestamp > highest) {
      highest = timestamp;
      filename = entry.name;
    }
  }

  return filename;
}
