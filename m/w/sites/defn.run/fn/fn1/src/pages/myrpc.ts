import { WorkerEntrypoint } from "cloudflare:workers";

export default class MyRPC extends WorkerEntrypoint {
  async fetch() {
    return new Response(null, { status: 404 });
  }

  async add(a: number, b: number) {
    return a + b;
  }
}
