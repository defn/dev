import { MyDurableObject } from "./mydo.ts";
export { MyDurableObject } from "./mydo.ts";

export async function GET(context: any) {
  const env = context.locals.runtime.env;
  const id = env.do1.idFromName("foo");
  const stub: MyDurableObject = env.do1.get(id);
  const response = await stub.sayHello();

  return new Response(JSON.stringify([env.GREETING, response]), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
  });
}
