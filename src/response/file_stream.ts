export async function fileStream(
  filePath: string,
  contentType = "application/octet-stream",
) {
  try {
    return new Response((await Deno.open(filePath)).readable, {
      headers: {
        "content-length": (await Deno.stat(filePath)).size.toString(),
        "content-type": contentType,
      },
    });
  } catch (e) {
    if (e instanceof Deno.errors.NotFound) {
      return new Response(null, { status: 404 });
    }
    return new Response(null, { status: 500 });
  }
}
