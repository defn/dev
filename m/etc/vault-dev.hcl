path "kv/*" {
  capabilities = ["list"]
}

path "kv/data/dev/*" {
  capabilities = ["create", "update", "patch", "read"]
}
