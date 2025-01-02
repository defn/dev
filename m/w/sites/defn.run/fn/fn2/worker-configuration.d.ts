import type { MyDurableObject } from "./src/pages";

interface Env {
  kv: KVNamespace;
  GREETING: "world";
  bucket: R2Bucket;
  db: D1Database;
  ASSETS: Fetcher;
  fndo: DurableObjectNamespace<MyDurableObject>;
  fnrpc: Fetcher;
}
