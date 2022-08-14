FROM rancher/k3s:v1.23.9-k3s1

ARG DEFN_DEV_ARCHIVE

RUN mv /bin/k3s /bin/k3s-real
COPY k3s-wrapper.sh /bin/k3s

COPY */tailscale */tailscaled ./

COPY argocd.yaml /var/lib/rancher/k3s/server/manifests/

RUN cd / && echo "${DEFN_DEV_ARCHIVE}" | base64 -d | tar xvf -
