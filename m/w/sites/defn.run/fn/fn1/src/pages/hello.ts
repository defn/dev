import type { APIContext } from "astro";
import type { APIRoute } from "astro";

import type { Env } from "./env.ts";

import type { MyDurableObject } from "./mydo.ts";
export { MyDurableObject } from "./mydo.ts";

export { MyRPC } from "./myrpc.ts";

export const GET: APIRoute = async function (context: APIContext) {
  const url = new URL(context.request.url);
  const params = new URLSearchParams(url.search);

  const env = context.locals.runtime.env;
  const id = env.fndo.idFromName(params.get("thing") ?? "null");
  const stub: MyDurableObject = env.fndo.get(id);

  const sum = await env.fnrpc.add(88, 1000);

  var response = await stub.sayHello(params.get("thing") ?? "null");

  return new Response(JSON.stringify([env.GREETING, response, sum]), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
  });
};
