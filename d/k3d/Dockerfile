FROM rancher/k3s:v1.23.10-k3s1

ARG DEFN_DEV_ARCHIVE

RUN echo root:x:0:0:root:/root:/bin/sh >> /etc/passwd
RUN echo root:x:0: >> /etc/group
RUN install -d -m 0700 -o root -g root /root

RUN mv /bin/k3s /bin/k3s-real
COPY k3s-wrapper.sh /bin/k3s

COPY */tailscale */tailscaled ./

COPY *.yaml /var/lib/rancher/k3s/server/manifests/

RUN cd / && echo "${DEFN_DEV_ARCHIVE}" | base64 -d | tar xvf -
