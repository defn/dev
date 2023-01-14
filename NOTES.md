https://www.vaultproject.io/docs/secrets/pki/quick-start-root-ca

    vault secrets enable pki
    vault secrets tune -max-lease-ttl=87600h pki
    vault delete pki/root; vault write pki/root/generate/internal common_name=gyre.defn.dev ttl=87600h -format=json | jq -r '.data.certificate' > root.crt
    vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

    vault write sys/policy/default policy=@default.hcl
    vault write sys/policy/dev policy=@dev.hcl
    vault write pki/roles/dev allowed_domains=demo.svc.cluster.local,${domain} allow_subdomains=true max_ttl=120h

    v write -f transit/keys/autounseal-remo
    v policy write autounseal-remo etc/vault-autounseal-remo-policy.hcl
