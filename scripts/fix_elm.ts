const file = Deno.args[0];

if (!file) {
  console.error("Please provide a file path as an argument.");
  Deno.exit(1);
}

Deno.writeTextFileSync(
  file,
  Deno.readTextFileSync(file).replace(/\(this\)\)\;$/g, "(globalThis));")
);
