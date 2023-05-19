import { serve } from "https://deno.land/std@0.184.0/http/server.ts";
import { getElm } from "./elm.ts"

const Elm = getElm();

Elm.Main.init();

console.log()


// function handler(_req: Request): Response {
//   return new Response("Hello, World!");
// }

// console.log("Listening on http://localhost:8000");

// serve(handler);
