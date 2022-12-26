vault write sys/policy/hello policy=@policy-hello.hcl

vault auth enable -path "$name" kubernetes

vault write "auth/$name/config" \
    kubernetes_host="$($name server)" \
    kubernetes_ca_cert=@<($name ca) \
    disable_local_ca_jwt=true

vault write "auth/$name/role/hello" \
    bound_service_account_names=default \
    bound_service_account_namespaces=default \
    policies=hello ttl=1h
