export { MyDurableObject } from "./mydo.ts";

export async function GET(context) {
  const env = context.locals.runtime;
  const id = env.mydo.idFromName("foo");
  const stub = env.mydo.get(id);
  const response = await stub.fetch(request);

  return new Response(JSON.stringify({ hello: response }), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
  });
}
