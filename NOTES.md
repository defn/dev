rm -rf ~/Library/Application\ Support/coderv2/postgres

coder server --access-url http://localhost:5555 --http-address localhost:5555 --oauth2-github-allow-signups=true --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) --oauth2-github-allow-signups --oauth2-github-allowed-orgs=$(pass coder_github_allowed_orgs)

coder login --first-user-email $(pass coder_admin_email) --first-user-password $(pass coder_admin_password) --first-user-username $(pass coder_admin_username) --first-user-trial=false http://localhost:5555

cd docker-code-server
coder template create --yes

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

    vault write sys/policy/default policy=@default.hcl
    vault write sys/policy/dev policy=@dev.hcl
    vault write pki/roles/dev allowed_domains=demo.svc.cluster.local,${domain} allow_subdomains=true max_ttl=120h

    v write -f transit/keys/autounseal-remo
    v policy write autounseal-remo etc/vault-autounseal-remo-policy.hcl
