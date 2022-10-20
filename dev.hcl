path "kv/data/dev/*" {
  capabilities = ["create", "update", "read"]
}

path "pki/issue/gyre.defn.dev" {
  capabilities = ["update"]
}
