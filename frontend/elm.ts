export interface Options {
  /** Change the path of the elm binary. */
  elm?: string;

  /** Change the location that elm is run. */
  cwd?: string;

  /** Turn on the time-travelling debugger. */
  debug?: boolean;

  /** Turn on optimizations to make code smaller and faster. */
  optimize?: boolean;

  /** Specify the name of the resulting JS file. */
  output?: string;

  /** Get error messages as JSON. Not useful as this command doesn't capture outputs. */
  report?: "json";

  /** Generate a JSON file of documentation for a package. */
  docs?: string;
}

export async function make(input: string, options?: Options) {
  const cmd = [
    options?.elm ?? "elm",
    "make",
    input,
    ...(options?.debug ? ["--debug"] : []),
    ...(options?.optimize ? ["--optimize"] : []),
    ...(options?.output ? [`--output=${options.output}`] : []),
    ...(options?.report ? [`--report=${options.report}`] : []),
    ...(options?.docs ? [`--docs=${options.docs}`] : []),
  ];

  console.log(...cmd);

  const process = Deno.run({
    cmd,
    cwd: options?.cwd ?? Deno.cwd(),
    stdin: "inherit",
    stderr: "inherit",
    stdout: "inherit",
  });

  return await process.status();
}
