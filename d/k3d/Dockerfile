FROM rancher/k3s:v1.23.9-k3s1

ARG DEFN_DEV_ARCHIVE

RUN mv /bin/k3s /bin/k3s-real
COPY k3s-wrapper.sh /bin/k3s

COPY */tailscale */tailscaled ./

RUN cd / && echo "${DEFN_DEV_ARCHIVE}" | base64 -d | tar xvfz - 
