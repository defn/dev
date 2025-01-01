import { DurableObject } from "cloudflare:workers";

export class MyDurableObject extends DurableObject {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env);
  }

  async sayHello(thing: string | null): Promise<string> {
    if (thing === null) {
      return "world!";
    } else {
      return `Hello, ${thing}! (fn1)`;
    }
  }
}
