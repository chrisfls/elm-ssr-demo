import postcss from "https://deno.land/x/postcss@8.4.16/mod.js";
import camelize from "https://esm.sh/camelize@1.0.1";
// @deno-types="npm:@types/prettier"
import prettier from "npm:prettier@2.8.8";

const tailwind =
  "https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css";
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

import Html exposing (Attribute)
import Html.Attributes exposing (class)
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

await Deno.writeTextFile("./Tailwind.elm", elm);
