https://www.vaultproject.io/docs/secrets/pki/quick-start-root-ca

# fly
```
docker run --privileged --rm tonistiigi/binfmt --install arm64

mkdir -p /tmp/etc/ssh
nix run .#ssh-keygen -- -A -f /tmp
nix run .#sshd -- -f ~/etc/sshd_config -o ListenAddress=0.0.0.0

gpg --armor --export | ssh "$ssh_host" gpg --import
gpg --export-ownertrust | ssh "$ssh_host" gpg --import-ownertrust
ln -nfs ln -nfs /home/ubuntu/.gnupg/S.gpg-agent /home/ubuntu/.gnupg/S.gpg-agent.extra /run/user/1000/gnupg/ /run/user/1000/gnupg/

nix run .#ssh -- \
-o StrictHostKeyChecking=no \
-o UserKnownHostsFile=/dev/null \
-o ServerAliveInterval=1 \
-o ServerAliveCountMax=10 \
-o ConnectTimeout=1 \
-o ConnectionAttempts=5 \
-o PasswordAuthentication=no \
-o StreamLocalBindUnlink=yes \
-o RemoteForward="/home/ubuntu/.gnupg/S.gpg-agent $HOME/.gnupg/S.gpg-agent.extra" \
-o RemoteForward="/home/ubuntu/.gnupg/S.gpg-agent.extra $HOME/.gnupg/S.gpg-agent.extra" \
-v -p 2222 -A ubuntu@$ssh_host bash -c '"ln -nfs $SSH_AUTH_SOCK $HOME/.ssh/S.ssh-agent; ssh-add -L; echo connected; exec sleep infinity"'

```

```
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault delete pki/root; vault write pki/root/generate/internal common_name=gyre.defn.dev ttl=87600h -format=json | jq -r '.data.certificate' > root.crt
vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

vault write sys/policy/default policy=@default.hcl
vault write sys/policy/dev policy=@dev.hcl
vault write pki/roles/dev allowed_domains=demo.svc.cluster.local,${domain} allow_subdomains=true max_ttl=120h

v write -f transit/keys/autounseal-remo
v policy write autounseal-remo etc/vault-autounseal-remo-policy.hcl

rm -f go/bin/derper
go install tailscale.com/cmd/derper@latest

cd .acme.sh/dir
ln -nfs the.crt derp.defn.run.crt
ln -nfs the.key derp.defn.run.key

go/bin/derper --hostname=derp.defn.run --certmode=manual --certdir=/Users/defn/.acme.sh/\*.defn.run -a=:3340 --stun=true --http-port=8080 --verify-clients=false -c=$HOME/etc/derper.conf

easyrsa init-pki
easyrsa build-ca
easyrsa build-server-full server
openssl rsa -in etc/openvpn/pki/private/server.key  -out etc/openvpn/pki/private/server2.key
openvpn etc/openvpn/server.conf
```
