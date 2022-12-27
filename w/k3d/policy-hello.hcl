path "kv/*" {
  capabilities = ["list"]
}

path "kv/data/hello/*" {
  capabilities = ["create", "update", "patch", "read"]
}
