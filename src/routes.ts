// import { contentType } from "std/media_types/content_type.ts";
// import * as path from "std/path/mod.ts";
// import * as fs from "std/fs/mod.ts";
// import { deferred } from "std/async/deferred.ts";

// import * as Eta from "eta";

// import * as elm from "./elm/mod.ts";
// import { findLastBundle } from "./elm/bundle.ts";
// import * as env from "./env.ts";
// import * as response from "./response/mod.ts";

// export const routes: Route[] = [
//   {
//     pattern: new URLPattern({ pathname: "/" }),
//     async handler(): Promise<Response> {
//       if (env.development) {
//         elm.compileFile("app/server/Main.elm", SERVER_ELM);
//       }

//       if (!await fs.exists("web/bundle.js")) {
//         return new Response(null, { status: 404 });
//       }

//       const app = (await elm.load<Ports>(SERVER_ELM)).Main.init({});
//       const response = deferred<Response>();

//       async function subscription(ssr: string) {
//         app.ports.ssr.unsubscribe(subscription);

//         response.resolve(
//           new Response(
//             await Eta.renderFileAsync("index", { bundle: CLIENT_ELM, ssr }),
//             {
//               status: 200,
//               headers: { "content-type": "text/html" },
//             },
//           ),
//         );
//       }

//       app.ports.ssr.subscribe(subscription);

//       return await response;
//     },
//   }
// ];
