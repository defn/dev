ARG DEFN_DEV_FROM

FROM ${DEFN_DEV_FROM}

ARG DEFN_DEV_ARCHIVE

COPY *.yaml /var/lib/rancher/k3s/server/manifests/

RUN cd / && if test -n "${DEFN_DEV_ARCHIVE}"; then echo "${DEFN_DEV_ARCHIVE}" | base64 -d | tar xvf -; fi
