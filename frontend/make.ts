export interface Options {
  /** Change the path of the elm binary. */
  elm?: string;

  /** Change the location that elm is run. */
  cwd?: string;

  /** Replace (this) with (globalThis). */
  deno?: boolean;

  /** Used to inject kernel code. */
  replace?: Replacement[];

  /** Turn on the time-travelling debugger. */
  debug?: boolean;

  /** Turn on optimizations to make code smaller and faster. */
  optimize?: boolean;

  /** Get error messages as JSON. Not useful as this command doesn't capture outputs. */
  report?: "json";

  /** Generate a JSON file of documentation for a package. */
  docs?: string;
}

export interface Replacement {
  where: string;
  replace(debug: boolean): string | Promise<string>;
}

function deno(content: string) {
  return content.replace(/\(this\)\)\;$/g, "(globalThis));");
}

async function replace(
  content: string,
  replacements: Replacement[],
  debug: boolean,
) {
  for (const { where, replace } of replacements) {
    content = content.replace(where.trim(), (await replace(debug)).trim());
  }

  return content;
}

export async function make(input: string, output: string, options?: Options) {
  const tmp = `${await Deno.makeTempFile()}.js`;
  const debug = options?.debug ?? false;
  const cwd = options?.cwd ?? Deno.cwd();

  const cmd = [
    options?.elm ?? "elm",
    "make",
    input,
    ...(options?.debug ? ["--debug"] : []),
    ...(options?.optimize ? ["--optimize"] : []),
    `--output=${tmp}`,
    ...(options?.report ? [`--report=${options.report}`] : []),
    ...(options?.docs ? [`--docs=${options.docs}`] : []),
  ];

  if (cwd !== Deno.cwd()) console.log("cd", cwd);
  console.log(...cmd);

  const process = Deno.run({
    cmd,
    cwd,
    stdin: "inherit",
    stderr: "inherit",
    stdout: "inherit",
  });

  const status = await process.status();
  const postprocess = options?.deno || (options?.replace?.length ?? 0) > 0;

  if (!status.success || !postprocess) {
    if (status.success) await Deno.copyFile(tmp, output);
    return status;
  }

  let content = await Deno.readTextFile(tmp);

  if (options?.replace && (options?.replace?.length ?? 0) > 0) {
    content = await replace(content, options.replace, debug);
  }

  if (options?.deno) content = deno(content);

  Deno.writeTextFile(output, content);
  return status;
}

export const replacements = {
  serverHtmlToJson: {
    where: `
var $author$project$Server$Html$toJson = function (_v0) {
\treturn $elm$json$Json$Encode$string('a7e4173c7ea41051bf56e286966e5acc195472204f0cf016ebbd94dde5f18ec7');
};
`,
    replace: async () => `
${await Deno.readTextFile("./server/src/Elm/Kernel/HtmlAsJson.js")}
var $author$project$Server$Html$toJson = _HtmlAsJson_toJson;
`,
  },
  serverMessageToJson: {
    where: `
var $author$project$Ports$callbackToJson = function (_v0) {
\treturn $elm$json$Json$Encode$string('669f628dd586bc07deb2eef6138aac7a0941bce4e2a8b4bfcfd8a41b18db7401');
};
`,
    replace: () => `
var $author$project$Ports$callbackToJson = function (message) {
\treturn _Json_succeed(message);
};
`,
  },
};

if (import.meta.main) {
  await make("src/Main.elm", `public/bundle.${Date.now()}.js`, {
    optimize: true,
  });

  await make("src/Server/Main.elm", "./bundle.js", {
    cwd: "./server",
    optimize: true,
    deno: true,
    replace: [
      replacements.serverHtmlToJson,
    ],
  });
}
