import postcss from "postcss";
import camelize from "camelize";
// @deno-types="npm:@types/prettier"
import prettier from "prettier";

import { tailwind } from "./deps.ts";

const version = (tailwind.match(/tailwindcss\/(.+)\//) ?? [])[1];

const response = await fetch(tailwind);
const content = await response.text();
const result = await postcss().process(content, { from: tailwind });

const rules = new Map<string, string[]>();
const classes: string[] = [];

let elm = `
module Tailwind exposing (..)

{-| Generated from Tailwind${` ${version}` ?? ""}.
-}

import Dual.Html exposing (Attribute)
import Dual.Html.Attributes exposing (class)
`;

result.root.walkRules((node) => {
  for (const selector of node.selector.split(/[,\s]/)) {
    if (!node.selector.startsWith(".")) return;

    const name = selector.trim()
      .replace(/>.+/, "")
      .replace(/^\./, "")
      .replace(/::placeholder$/, "")
      .replace(/:(focus-within|focus|hover)$/, "")
      .replace(/^\\32xl/, "2xl")
      .replaceAll("\\", "");

    const sources = rules.get(name);
    const source = "    " + prettier.format(node.toString(), { parser: "css" })
      .replaceAll("\n", "\n    ")
      .trimEnd();

    if (sources) {
      sources.push(source);
    } else {
      rules.set(name, [source]);
      classes.push(name);
    }
  }
});

const empty: string[] = [];

for (const name of classes) {
  const sanitized = (camelize(
    name
      .replace(/^-/, "neg-")
      .replace(/^2xl/, "xxl")
      .replaceAll(":-", "-neg-")
      .replaceAll(":", "-")
      .replace(".", "$")
      .replace("/", "-over-"),
  ) as string).replace("$", "o");

  const sources = rules.get(name) ?? empty;
  const source = sources.join("\n\n");
  const documentation = sources.length === 0
    ? `Maps to \`${name}\`.`
    : `Maps to \`${name}\`:\n\n${source}`;

  elm += `\n\n{-| ${documentation}\n-}\n`;
  elm += `${sanitized} : Attribute msg\n`;
  elm += `${sanitized} =\n    class ${JSON.stringify(name)}\n`;
}

await Deno.writeTextFile("./client/lib/Tailwind.elm", elm);
