import { serve } from "std/http/server.ts";

import { make } from "./elm.ts";
import { createHandler } from "./server.ts";

const tmp = async () => `${await Deno.makeTempFile()}.js`;

const client = await tmp();
const server = await tmp();

await make("src/Main.elm", {
  cwd: "./client",
  debug: true,
  output: client,
});

await make("src/Main.elm", {
  cwd: "./server",
  debug: true,
  output: server,
  deno: true,
});

await serve(await createHandler({ client, server }));
