#!/usr/bin/env bash

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
- name: tailscale-certificate
  kind: Secret
  executeHookOnEvent: ["Added"]
  nameSelector:
    matchNames:
    - default-certificate
  namespace:
    nameSelector:
      matchNames:
      - raefik
  labelSelector:
    matchExpressions:
    - key: "source"
      operator: "NoIn"
      values: ["tailscale"]
EOF
  exit 0
fi


nsName="$(jq -r .[0].object.metadata.name $BINDING_CONTEXT_PATH)"
echo "Namespace '${nsName}' added"

cd

cp "$BINDING_CONTEXT_PATH" work/tmp/

source .bashrc
make kubeconfig
d="$(docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert 2>&1 | grep For.domain | cut -d'"' -f2)"
docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert $d
docker exec tailscale_docker-extension-desktop-extension-service tar cvfz - $d.crt $d.key > /tmp/$d.tar.gz
kubectl --context pod -n traefik delete secret default-certificate
kubectl --context pod create -n traefik secret generic default-certificate --from-file tls.crt=<(tar xfz /tmp/$d.tar.gz -O $d.crt) --from-file tls.key=<(tar xfz /tmp/$d.tar.gz -O $d.key)
kubectl --context pod label -n traefik secret default-certificate source=tailscale
