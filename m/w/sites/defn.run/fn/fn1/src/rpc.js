import { WorkerEntrypoint } from "cloudflare:workers";

export class MyRPC extends WorkerEntrypoint {
  async fetch() {
    return new Response(null, { status: 404 });
  }

  async add(a, b) {
    return a + b;
  }
}
