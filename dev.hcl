path "kv/*" {
  capabilities = ["list"]
}

path "kv/data/dev/*" {
  capabilities = ["create", "update", "patch", "read"]
}

path "pki/issue/gyre.defn.dev" {
  capabilities = ["update"]
}
