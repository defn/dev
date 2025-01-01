import { MyDurableObject } from "./mydo.ts";
export { MyDurableObject } from "./mydo.ts";

export async function GET(context: any) {
  const env = context.locals.runtime.env;
  const id = env.fndo.idFromName("foo");
  const stub: MyDurableObject = env.fndo.get(id);

  const url = new URL(context.request.url);
  const params = new URLSearchParams(url.search);

  var response = await stub.sayHello(params.get("thing"));

  return new Response(JSON.stringify([env.GREETING, response]), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
  });
}
