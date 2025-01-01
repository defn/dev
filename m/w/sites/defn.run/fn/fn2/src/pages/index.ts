import type { APIContext } from "astro";

import type { MyDurableObject } from "./mydo.ts";
export { MyDurableObject } from "./mydo.ts";

import type { MyRPC } from "./myrpc.ts";
export { MyRPC } from "./myrpc.ts";

export async function GET(context: APIContext) {
  const url = new URL(context.request.url);
  const params = new URLSearchParams(url.search);

  const env = context.locals.runtime.env;
  const id = env.fndo.idFromName("foo");
  const stub: MyDurableObject = env.fndo.get(id);

  const sum = await env.fnrpc.add(88, 1000);

  var response = await stub.sayHello(params.get("thing"));

  return new Response(JSON.stringify([env.GREETING, response, sum]), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
  });
}
