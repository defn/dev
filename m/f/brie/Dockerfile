FROM ubuntu:24.04 AS nix

RUN apt-get update && apt-get install -y xz-utils curl sudo git make direnv gpg rsync

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN rm -rf /home/ubuntu && install -d -o ubuntu -g ubuntu -m 0755 /home/ubuntu

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu

RUN git clone https://github.com/defn/dev /home/ubuntu
RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
RUN bash -c 'source .bash_profile && make nix'

RUN bash -c 'source .bash_profile && cd m/pkg/cue && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/gum && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/vhs && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/glow && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/dyff && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/az && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/home && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/secrets && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/acme && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/tailscale && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/cloudflared && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/cloudflareddns && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/wireproxy && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/vpn && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/openfga && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/utils && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/just && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/buildifier && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/bazelisk && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/ibazel && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/oci && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/development && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/terraform && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/terraformdocs && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/packer && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/step && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/awscli && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/chamber && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/cloud && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/kubectl && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/minikube && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/minikubekvm2 && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/k3sup && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/k9s && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/helm && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/kustomize && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/stern && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/argoworkflows && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/argocd && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/kn && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/dapr && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/vcluster && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/kubevirt && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/linkerd && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/kuma && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/cilium && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/hubble && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/tfo && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/mirrord && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/crossplane && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/spire && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/coder && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/codeserver && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/tilt && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/gh && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/ghapps && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/earthly && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/flyctl && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/oras && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/regctl && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/regbot && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/regsync && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/buildkite && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/buildevents && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/honeyvent && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/honeymarker && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/honeytail && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/hugo && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/vault && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/godev && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/jsdev && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/pydev && b build'
RUN bash -c 'source .bash_profile && cd m/pkg/shell && b build'

RUN bash -c 'source .bash_profile && make install'

RUN rm -rf .git work
RUN bash -c 'source .bash_profile && bin/persist-cache && cd m && b clean'

FROM ghcr.io/coder/coder:latest

COPY --from=nix /home/ubuntu /home/ubuntu
COPY --from=nix /nix /nix