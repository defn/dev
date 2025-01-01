import type { MyDurableObject } from "./src/pages";
import type { MyRPC } from "./src/pages";

interface Env {
  kv: KVNamespace;
  GREETING: "world";
  fndo: DurableObjectNamespace<MyDurableObject>;
  bucket: R2Bucket;
  db: D1Database;
  ASSETS: Fetcher;
  do1: Fetcher;
}
