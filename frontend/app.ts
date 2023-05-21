/// <reference lib="dom" />

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
  headers: { [key: string]: string };
}

export interface TimeoutPort {
  id: number;
  type: "abort";
}

export interface HtmlPort {
  id: number;
  value: string;
}

export interface ErrorPort {
  id: number;
  value: string;
}

export interface Ports {
  http: Send<HttpPort>;
  timeout: Send<TimeoutPort>;
  html: Subscription<HtmlPort>;
  error: Subscription<ErrorPort>;
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
  return globalThis as unknown as Elm;
}
