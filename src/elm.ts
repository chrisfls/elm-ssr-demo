/// <reference lib="dom" />

import "../web/index.js";

export interface PortWithSend<Message = unknown> {
  send(value: Message): void;
}

export interface PortWithSubscription<Message = unknown> {
  subscribe(handler: (value: Message) => void): void;
  unsubscribe(handler: (value: Message) => void): void;
}

export interface Ports<Message = unknown> {
  [name: string]: PortWithSend<Message> | PortWithSubscription<Message>
}

export interface ElmApp<P extends Ports = Ports> {
  ports: P;
}

export interface ElmMain<P extends Ports = Ports> {
  init(options: { node?: Node | undefined; flags?: unknown }): ElmApp<P>;
}

export interface Elm<P extends Ports = Ports> {
  Main: ElmMain<P>
}

export function getElm<P extends Ports = Ports>(): Elm<P> {
  // deno-lint-ignore no-explicit-any
  return (globalThis as unknown as { Elm: Elm<any> })['Elm'];
}
