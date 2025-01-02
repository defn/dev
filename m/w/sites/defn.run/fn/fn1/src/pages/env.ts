export interface Env<T> {
  kv: KVNamespace;
  GREETING: "world";
  bucket: R2Bucket;
  db: D1Database;
  ASSETS: Fetcher;
  fndo: DurableObjectNamespace;
  fnrpc: Fetcher;
}
