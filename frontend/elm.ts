/// <reference lib="dom" />

import * as path from "std/path/mod.ts";
import "xhr";

export interface Send<Message> {
  send(message: Message): void;
}

export interface Subscription<Message> {
  subscribe(handler: (message: Message) => void): void;
  unsubscribe(handler: (message: Message) => void): void;
}

export interface HttpPort {
  id: number;
  url: string;
  headers: { [key: string]: string[] };
}

export interface LoggerPort {
  level: "debug" | "error" | "info" | "log" | "trace" | "warn";
  message: string;
}

export interface CancelPort {
  id: number;
}

export interface HtmlPort {
  id: number;
  view: string;
  model: unknown;
}

export interface Ports {
  httpPort: Send<HttpPort>;
  cancelPort: Send<CancelPort>;
  htmlPort: Subscription<HtmlPort>;
  loggerPort: Subscription<LoggerPort>;
  sendPort: Subscription<
    { message: unknown; callback: (message: unknown) => unknown }
  >;
}

export interface App {
  ports: Ports;
}

// deno-lint-ignore no-empty-interface
export interface Flags {
}

export interface Main {
  init(options?: { node?: Node | undefined; flags: Flags }): App;
}

export interface Elm {
  Server: { Main: Main };
}

export async function load(filePath: string): Promise<Elm> {
  const { Elm } = await import(
    filePath.slice(0, filePath.length - path.extname(filePath).length) + ".ts"
  ) as typeof import("./bundle.ts");
  return Elm as unknown as Elm;
}
