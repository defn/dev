    ssh: on remote: gpgconf  --list-dirs
        Host
        Hostname
        User ubuntu
        Port 2222
        ForwardAgent true
        StreamLocalBindUnlink yes
        RemoteForward /home/ubuntu/.gnupg/S.gpg-agent /Users/defn/.gnupg/S.gpg-agent.extra
        RemoteForward /home/ubuntu/.gnupg/S.gpg-agent.extra /Users/defn/.gnupg/S.gpg-agent.extra
        StrictHostKeyChecking no
        UserKnownHostsFile=/dev/null
        ServerAliveInterval 60
        ServerAliveCountMax 5

https://www.vaultproject.io/docs/secrets/pki/quick-start-root-ca

    vault secrets enable pki
    vault secrets tune -max-lease-ttl=87600h pki
    vault delete pki/root; vault write pki/root/generate/internal common_name=gyre.defn.dev ttl=87600h -format=json | jq -r '.data.certificate' > root.crt
    vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
    vault write sys/policy/gyre.defn.dev policy=@etc/policy-gyre.defn.dev.hcl

    vault auth enable kubernetes
    vault write auth/kubernetes/config kubernetes_host=https://kubernetes.default.svc.cluster.local
    vault write auth/kubernetes/role/demo bound_service_account_names=default bound_service_account_namespaces=default policies=gyre.defn.dev ttl=1h

    kubectl --context pod patch -n vc1 service kourier-internal-x-kourier-system-x-vc1 -p '{"metadata":{"annotations":{"traefik.ingress.kubernetes.io/service.serversscheme":"h2c"}}}'

    v write pki/roles/gyre.defn.dev allowed_domains=demo.svc.cluster.local,${domain} allow_subdomains=true max_ttl=120h

    v write -f transit/keys/autounseal-remo
    v policy write autounseal-remo etc/vault-autounseal-remo-policy.hcl
