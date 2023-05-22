/// <reference lib="dom" />

import XMLHttpRequest from "xhr-shim";

globalThis["XMLHttpRequest"] = XMLHttpRequest;

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

export interface ErrorPort {
  id: number;
  reason: unknown;
}

export interface TimeoutPort {
  id: number;
}

export interface HtmlPort {
  id: number;
  view: string;
  model: unknown;
}

export interface Ports {
  httpPort: Send<HttpPort>;
  timeoutPort: Send<TimeoutPort>;
  htmlPort: Subscription<HtmlPort>;
  errorPort: Subscription<ErrorPort>;
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
  await import(filePath);
  return (globalThis as unknown as { Elm: Elm })["Elm"];
}
