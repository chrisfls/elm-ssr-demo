/// <reference lib="dom" />

import XMLHttpRequest from "xhr-shim";

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
  Main: Main;
}

export async function load(filePath: string): Promise<Elm> {
  if (globalThis["XMLHttpRequest"] == null) {
    globalThis["XMLHttpRequest"] = XMLHttpRequest;
  }

  await import(filePath);

  return (globalThis as unknown as { Elm: Elm })["Elm"];
}
