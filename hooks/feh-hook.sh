#!/usr/bin/env bash

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
- name: tailscale-certificate
  apiVersion: traefik.containo.us/v1alpha1
  kind: TLSStore
  executeHookOnEvent: ["Added"]
  nameSelector:
    matchNames:
    - default
  namespace:
    nameSelector:
      matchNames:
      - traefik
EOF
  exit 0
fi

if [[ "$(cat $BINDING_CONTEXT_PATH | jq -r '[.[].objects][] | length')" == 0 ]]; then
  exit 0
fi

cd

cp "$BINDING_CONTEXT_PATH" work/tmp/

source .bashrc
make kubeconfig
d="$(docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert 2>&1 | grep For.domain | cut -d'"' -f2)"
docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert $d
docker exec tailscale_docker-extension-desktop-extension-service tar cvfz - $d.crt $d.key > /tmp/$d.tar.gz
kubectl --context pod -n traefik delete secret default-certificate
kubectl --context pod create -n traefik secret generic default-certificate --from-file tls.crt=<(tar xfz /tmp/$d.tar.gz -O $d.crt) --from-file tls.key=<(tar xfz /tmp/$d.tar.gz -O $d.key)
