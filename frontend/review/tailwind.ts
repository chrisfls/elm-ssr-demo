import postcss from "https://deno.land/x/postcss@8.4.16/mod.js";

const tailwind =
  "https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css";
const version = (tailwind.match(/tailwindcss\/(.+)\//) ?? [])[1];

const response = await fetch(tailwind);
const content = await response.text();
const result = await postcss().process(content, { from: tailwind });

const rules = new Set<string>();

let elm = `module NoInvalidTailwindClass.Classes exposing (classes)

{-| Generated from Tailwind${` ${version}` ?? ""}.
-}

import Set exposing (Set)

classes : Set String
classes =
    Set.fromList
`;

let first = true;

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

    if (rules.has(name)) continue;
    rules.add(name);

    if (first) {
      first = false;
      elm += `[ ${JSON.stringify(name)}`;
    } else {
      elm += `, ${JSON.stringify(name)}`;
    }
  }
});

elm += "]\n";

await Deno.writeTextFile("./src/NoInvalidTailwindClass/Classes.elm", elm);
