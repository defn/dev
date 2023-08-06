path "kv/*" {
  capabilities = ["list"]
}

path "kv/data/*" {
  capabilities = ["create", "update", "patch", "read"]
}
