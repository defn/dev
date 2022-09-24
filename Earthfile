VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker 0.6

IMPORT github.com/defn/cloud/lib:master AS lib

build-amd:
    FROM --platform=linux/amd64 +user --arch=amd64

build-arm:
    FROM --platform=linux/arm64 +user --arch=arm64

images:
    ARG repo
    ARG tag
    BUILD +image-amd --repo=${repo} --tag=${tag}
    BUILD +image-arm --repo=${repo} --tag=${tag}

image-amd:
    ARG repo
    ARG tag
    FROM --platform=linux/amd64 +user --arch=amd64

    SAVE IMAGE --push ${repo}defn/dev:${tag}

image-arm:
    ARG repo
    ARG tag
    FROM --platform=linux/arm64 +user --arch=arm64

    SAVE IMAGE --push ${repo}defn/dev:${tag}

user:
    ARG arch

    FROM +root --arch=${arch}

    ENTRYPOINT ["/usr/bin/tini", "--"]

    COPY --chown=ubuntu:ubuntu --dir --symlink-no-follow (+pipx/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+cdktf/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+golang/* --arch=${arch}) ./

    # gcloud
    COPY --chown=ubuntu:ubuntu --dir (+gcloud/gcloud --arch=${arch}) /usr/local/

    # arch3: awscli
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu --dir (+awscli/aws-cli --arch=${arch} --arch3=aarch64) /usr/local/
    ELSE
        COPY --chown=ubuntu:ubuntu --dir (+awscli/aws-cli --arch=${arch} --arch3=x86_64) /usr/local/
    END

    # arch
    COPY --chown=ubuntu:ubuntu (+powerline/* --arch=${arch}) /usr/local/bin
    COPY --chown=ubuntu:ubuntu (+vcluster/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+gh/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+earthly/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+cue/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+step/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+kuma/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+switch/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+cue-gen/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+kn/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+credentialPass/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+k3d/* --arch=amd64) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+tctl/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+gotools/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+temporalite/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+oras/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+caddy/* --arch=${arch}) /usr/local/bin/

    COPY --chown=ubuntu:ubuntu --dir (+shell/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+k9s/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+kustomize/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir --symlink-no-follow (+krew/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+helm/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+vault/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+cloudflared/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+terraform/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+skaffold/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+awsvault/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+argo/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+argocd/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+buf/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+grpcurl/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+packer/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+doctl/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+nomad/* --arch=${arch}) ./

    # arch2: hof, tilt
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu (+hof/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+tilt/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+goreleaser/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
    ELSE
        COPY --chown=ubuntu:ubuntu (+hof/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+tilt/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+goreleaser/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
    END

    # arch4
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu (+protoc/* --arch=${arch} --arch4=aarch_64) /usr/local/bin/
    ELSE
        COPY --chown=ubuntu:ubuntu (+protoc/* --arch=${arch} --arch4=x86_64) /usr/local/bin/
    END

    COPY --chown=ubuntu:ubuntu --symlink-no-follow --dir (+coderServer/* --arch=${arch}) ./
    #COPY --chown=ubuntu:ubuntu --symlink-no-follow --dir (+vscodeServer/* --arch=${arch}) /usr/local/bin/

    # shell-operator
    # COPY --dir (+shell-operator/sf.tar.gz --arch=${arch}) /
    # RUN cd / && sudo tar xvfz sf.tar.gz && sudo rm -f sf.tar.gz

    # rerun-process-wrapper
    # COPY (+rerun-process-wrapper/*) /

    # steampipe
    COPY --chown=ubuntu:ubuntu (+steampipe/* --arch=${arch}) /usr/local/bin/
    RUN steampipe plugin install kubernetes
    RUN steampipe plugin install docker
    RUN steampipe plugin install aws
    RUN steampipe plugin install digitalocea

    # arch2: flyctl
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu (+flyctl/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
    ELSE
        COPY --chown=ubuntu:ubuntu (+flyctl/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
    END

    # new, unorganized

    RUN ssh -o StrictHostKeyChecking=no git@github.com true || true

    RUN mkdir -p .kube .docker

    COPY --chown=ubuntu:ubuntu etc/config.json .docker/config.json

    COPY --chown=ubuntu:ubuntu --dir .vim .
    COPY --chown=ubuntu:ubuntu .vimrc .
    RUN echo yes | vim +PlugInstall +qall

    COPY --chown=ubuntu:ubuntu --dir bin .
    COPY --chown=ubuntu:ubuntu .bash* .

    COPY --chown=ubuntu:ubuntu +toolVersions/* .
    RUN ~/bin/e asdf install

    COPY --dir --chown=ubuntu:ubuntu . .
    RUN git clean -nfd || true
    RUN set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd


root:
    ARG arch

    FROM ubuntu:focal-20220531

    USER root
    ENTRYPOINT ["tail", "-f", "/dev/null"]

    ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ENV LANG en_US.UTF-8
    ENV LANGUAGE en_US:en
    ENV LC_ALL en_US.UTF-8

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

    RUN apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
        apt-transport-https software-properties-common \
        openssh-client openssh-server tzdata locales iputils-ping iproute2 net-tools dnsutils curl wget unzip xz-utils rsync \
        sudo git vim less fzf jo gron jq \
        build-essential default-jdk make tini python3-pip python3-venv entr \
        gpg pass pass-extension-otp git-crypt oathtool libusb-1.0-0 libolm-dev \
        xdg-utils figlet lolcat socat netcat-openbsd groff \
        screen htop \
        redis \
        wireguard-tools

	RUN apt purge -y nano

    RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
        && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
        && apt-get update \
        && apt install -y tailscale

    RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
        && echo "deb [arch=${arch} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | tee /etc/apt/sources.list.d/docker.list \
        && apt-get update \
        && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
    RUN usermod --groups docker --append ubuntu
    RUN echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu
    RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

    RUN apt update && apt upgrade -y
    RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
        && locale-gen en_US.UTF-8 \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

    RUN rm -f /usr/bin/gs

    RUN ln -nfs /usr/bin/git-crypt /usr/local/bin/

    RUN mkdir /run/sshd

    RUN chown -R ubuntu:ubuntu /home/ubuntu
    RUN chmod u+s /usr/bin/sudo

    USER ubuntu
    WORKDIR /home/ubuntu

    ENV HOME=/home/ubuntu

toolVersions:
    FROM ubuntu:focal-20220531
    ARG ARGO
    ARG ARGOCD
    ARG AWSVAULT
    ARG BUF
    ARG CLOUDFLARED
    ARG DOCTL
    ARG GOLANG
    ARG GRPCURL
    ARG HELM
    ARG K3SUP
    ARG K9S
    ARG KREW
    ARG KUBECTL
    ARG KUSTOMIZE
    ARG NODEJS
    ARG NOMAD
    ARG PACKER
    ARG SHELLCHECK
    ARG SHFMT
    ARG SKAFFOLD
    ARG TERRAFORM
    ARG VAULT

    RUN echo argo ${ARGO} >> .tool-versions
    RUN echo argocd ${ARGOCD} >> .tool-versions
    RUN echo aws-vault ${AWSVAULT} >> .tool-versions
    RUN echo buf ${BUF} >> .tool-versions
    RUN echo cloudflared ${CLOUDFLARED} >> .tool-versions
    RUN echo doctl ${DOCTL} >> .tool-versions
    RUN echo golang ${GOLANG} >> .tool-versions
    RUN echo grpcurl ${GRPCURL} >> .tool-versions
    RUN echo helm ${HELM} >> .tool-versions
    RUN echo k9s ${K9S} >> .tool-versions
    RUN echo krew ${KREW} >> .tool-versions
    RUN echo kubectl ${KUBECTL} >> .tool-versions
    RUN echo kustomize ${KUSTOMIZE} >> .tool-versions
    RUN echo nodejs ${NODEJS} >> .tool-versions
    RUN echo nomad ${NOMAD} >> .tool-versions
    RUN echo packer ${PACKER} >> .tool-versions
    RUN echo python ${PYTHON} >> .tool-versions
    RUN echo shellcheck ${SHELLCHECK} >> .tool-versions
    RUN echo shfmt ${SHFMT} >> .tool-versions
    RUN echo skaffold ${SKAFFOLD} >> .tool-versions
    RUN echo terraform ${TERRAFORM} >> .tool-versions
    RUN echo vault ${VAULT} >> .tool-versions
    RUN echo argo ${ARGO} >> .tool-versions
    SAVE ARTIFACT .tool-versions

coderServer:
    ARG arch
    ARG CODESERVER

    FROM +root --arch=${arch}

    RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone --prefix=/home/ubuntu/.local
    RUN mkdir -p .config/code-server && touch .config/code-server/config.yaml
    RUN git clone https://github.com/cue-sh/vscode-cue /home/ubuntu/.local/share/code-server/extensions/vscode-cue
    RUN for a in betterthantomorrow.calva betterthantomorrow.joyride ms-python.python golang.Go vscodevim.vim; do /home/ubuntu/.local/bin/code-server --install-extension "$a"; done
    SAVE ARTIFACT .local

vscodeServer:
    ARG arch
    ARG CODESERVER

    FROM +root --arch=${arch}

    # vscode-server
    RUN echo ${CODESERVER}
    RUN wget -O- https://aka.ms/install-vscode-server/setup.sh | sudo sh -x
    SAVE ARTIFACT /usr/local/bin/code-server

tools:
    FROM ubuntu:focal-20220531

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

    RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            apt-transport-https software-properties-common tzdata locales git gpg gpg-agent unzip xz-utils wget curl

    SAVE IMAGE --cache-hint

asdf:
    ARG arch
    ARG ASDF
    FROM +tools --arch=${arch}
    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
    RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu
    USER ubuntu
    WORKDIR /home/ubuntu
    RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${ASDF}
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'

    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint

# arch4
protoc:
    ARG arch
    ARG arch4
    ARG PROTOC
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC}/protoc-${PROTOC}-linux-${arch4}.zip -o "protoc.zip"
    RUN unzip protoc.zip
    SAVE ARTIFACT bin/protoc

# arch3
awscli:
    ARG arch
    ARG arch3
    ARG AWSCLI
    FROM +tools --arch=${arch}
    RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch3}.zip" -o "awscliv2.zip"
    RUN unzip awscliv2.zip
    RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/aws-cli/bin
    RUN curl -sSL -o /usr/local/aws-cli/bin/aws_signing_helper https://s3.amazonaws.com/roles-anywhere-credential-helper/CredentialHelper/latest/linux_amd64/aws_signing_helper && chmod 755 /usr/local/aws-cli/bin/aws_signing_helper
    SAVE ARTIFACT /usr/local/aws-cli

# arch2
hof:
    ARG arch
    ARG arch2
    ARG HOF
    FROM +tools --arch=${arch}
    RUN curl -sSL -o hof https://github.com/hofstadter-io/hof/releases/download/v${HOF}/hof_${HOF}_Linux_${arch2} && chmod 755 hof
    SAVE ARTIFACT hof

jless:
    ARG arch
    ARG arch2
    ARG JLESS
    FROM +tools --arch=${arch}
    RUN --secret JLESS (curl -sSL https://github.com/PaulJuliusMartinez/jless/releases/download/v${JLESS}/jless-v${JLESS}-x86_64-unknown-linux-gnu.zip | gunzip -c - > jless) && chmod 755 jless
    SAVE ARTIFACT jless

oras:
    ARG arch
    ARG ORAS
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/oras-project/oras/releases/download/v${ORAS}/oras_${ORAS}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT oras

caddy:
    ARG arch
    ARG CADDY
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/caddyserver/caddy/releases/download/v${CADDY}/caddy_${CADDY}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT caddy

flyctl:
    ARG arch
    ARG arch2
    ARG FLYCTL
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/superfly/flyctl/releases/download/v${FLYCTL}/flyctl_${FLYCTL}_Linux_${arch2}.tar.gz | tar xvfz -
    SAVE ARTIFACT flyctl

nerdctl:
    ARG arch
    ARG NERDCTL
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/containerd/nerdctl/releases/download/v${NERDCTL}/nerdctl-${NERDCTL}-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT nerdctl

difft:
    ARG arch
    ARG arch2
    ARG DIFFT
    FROM +tools --arch=${arch}
    RUN --secret DIFFT curl -sSL https://github.com/Wilfred/difftastic/releases/download/${DIFFT}/difft-x86_64-unknown-linux-gnu.tar.gz | tar xvfz -
    SAVE ARTIFACT difft

tilt:
    ARG arch
    ARG arch2
    ARG TILT
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/tilt-dev/tilt/releases/download/v${TILT}/tilt.${TILT}.linux.${arch2}.tar.gz | tar xvfz -
    SAVE ARTIFACT tilt

goreleaser:
    ARG arch
    ARG arch2
    ARG GORELEASER
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER}/goreleaser_Linux_${arch2}.tar.gz | tar xvfz -
    SAVE ARTIFACT goreleaser

# arch
credentialPass:
    ARG arch
    ARG CREDENTIALPASS
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/docker/docker-credential-helpers/releases/download/v${CREDENTIALPASS}/docker-credential-pass-v${CREDENTIALPASS}.linux-${arch} > docker-credential-pass && chmod 755 docker-credential-pass
    SAVE ARTIFACT docker-credential-pass

powerline:
    ARG arch
    ARG POWERLINE
    FROM +tools --arch=${arch}
    RUN curl -sSL -o powerline https://github.com/justjanne/powerline-go/releases/download/v${POWERLINE}/powerline-go-linux-${arch} && chmod 755 powerline
    SAVE ARTIFACT powerline

tctl:
    ARG arch
    ARG TEMPORAL
    FROM --platform=${arch} temporalio/admin-tools:${TEMPORAL}
    SAVE ARTIFACT /usr/local/bin/tctl

temporalite:
    ARG arch
    ARG TEMPORAL
    ARG TEMPORALITE
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/temporalio/temporalite/releases/download/v${TEMPORALITE}/temporalite_${TEMPORALITE}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT temporalite

step:
    ARG arch
    ARG STEP
    FROM +tools --arch=${arch}
    RUN echo 1
    RUN curl -sSL https://github.com/smallstep/cli/releases/download/v${STEP}/step_linux_${STEP}_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT */bin/step

cilium:
    ARG arch
    ARG CILIUM
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cilium/cilium-cli/releases/download/v${CILIUM}/cilium-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cilium

hubble:
    ARG arch
    ARG HUBBLE
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cilium/hubble/releases/download/v${HUBBLE}/hubble-linux-${arch}.tar.gz | tar xzvf -
    SAVE ARTIFACT hubble

linkerd:
    ARG arch
    ARG LINKERD
    FROM +tools --arch=${arch}
    RUN curl -sSL -o linkerd https://github.com/linkerd/linkerd2/releases/download/${LINKERD}/linkerd2-cli-${LINKERD}-linux-${arch} && chmod 755 linkerd
    SAVE ARTIFACT linkerd

vcluster:
    ARG arch
    ARG VCLUSTER
    FROM +tools --arch=${arch}
    RUN curl -sSL -o vcluster https://github.com/loft-sh/vcluster/releases/download/v${VCLUSTER}/vcluster-linux-${arch} && chmod 755 vcluster
    SAVE ARTIFACT vcluster

loft:
    ARG arch
    ARG LOFT
    FROM +tools --arch=${arch}
    RUN curl -sSL -o loft https://github.com/loft-sh/loft/releases/download/v${OFT}/loft-linux-${arch} && chmod 755 loft
    SAVE ARTIFACT loft

steampipe:
    ARG arch
    ARG STEAMPIPE
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/turbot/steampipe/releases/download/v${STEAMPIPE}/steampipe_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT steampipe

gh:
    ARG arch
    ARG GH
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cli/cli/releases/download/v${GH}/gh_${GH}_linux_${arch}.tar.gz | tar xvfz - --wildcards '*/bin/gh' && mv */bin/gh .
    SAVE ARTIFACT gh

earthly:
    ARG arch
    ARG EARTHLY
    FROM +tools --arch=${arch}
    RUN curl -sSL -o earthly https://github.com/earthly/earthly/releases/download/v${EARTHLY}/earthly-linux-${arch} && chmod 755 earthly
    SAVE ARTIFACT earthly

buildkite:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret BUILDKITE curl -sSL https://github.com/buildkite/agent/releases/download/v${BUILDKITE}/buildkite-agent-linux-${arch}-${BUILDKITE}.tar.gz | tar xvfz -
    SAVE ARTIFACT buildkite-agent

bk:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret BKCLI curl -sSL -o bk https://github.com/buildkite/cli/releases/download/v${BKCLI}/cli-linux-${arch} && chmod 755 bk
    SAVE ARTIFACT bk

litestream:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret LITESTREAM curl -sSL https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM}/litestream-v${LITESTREAM}-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT litestream

switch:
    ARG arch
    ARG SWITCH
    FROM +tools --arch=${arch}
    RUN curl -sSL -o switch https://github.com/danielfoehrKn/kubeswitch/releases/download/${SWITCH}/switcher_linux_amd64 && chmod 755 switch
    SAVE ARTIFACT switch

cue:
    ARG arch
    ARG CUE
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cue-lang/cue/releases/download/v${CUE}/cue_v${CUE}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cue

kuma:
    ARG arch
    ARG KUMA
    FROM +tools --arch=${arch}
    RUN curl -sSL https://download.konghq.com/mesh-alpine/kuma-${KUMA}-ubuntu-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT */bin/*

kn:
    ARG arch
    ARG KN
    FROM +tools --arch=${arch}
    RUN curl -sSL -o kn https://github.com/knative/client/releases/download/knative-v${KN}/kn-linux-${arch} && chmod 755 kn
    SAVE ARTIFACT kn

k3d:
    ARG arch
    ARG K3D
    FROM +tools --arch=${arch}
    RUN curl -sSL -o k3d https://github.com/k3d-io/k3d/releases/download/v${K3D}/k3d-linux-${arch} && chmod 755 k3d
    SAVE ARTIFACT k3d

fulcio:
    ARG arch
    ARG FULCIO
    FROM +tools --arch=${arch}
    RUN curl -sSL -o fulcio https://github.com/sigstore/fulcio/releases/download/v${FULCIO}/fulcio-linux-${arch} && chmod 755 fulcio
    SAVE ARTIFACT fulcio

rekor:
    ARG arch
    ARG REKOR
    FROM +tools --arch=${arch}
    RUN curl -sSL -o rekor https://github.com/sigstore/rekor/releases/download/v${REKOR}/rekor-cli-linux-${arch} && chmod 755 rekor
    SAVE ARTIFACT rekor

cosign:
    ARG arch
    ARG COSIGN
    FROM +tools --arch=${arch}
    RUN curl -sSL -o cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN}/cosign-linux-${arch} && chmod 755 cosign
    SAVE ARTIFACT cosign

gcloud:
    ARG arch
    FROM +tools --arch=${arch}
    RUN curl https://sdk.cloud.google.com > install.sh
    RUN bash install.sh --disable-prompts --install-dir=/usr/local/gcloud \
        && rm -rf $(find /usr/local/gcloud -regex ".*/__pycache__") \
        && rm -rf /usr/local/gcloud/google-cloud-sdk/.install/.backup
    RUN /usr/local/gcloud/google-cloud-sdk/bin/gcloud --quiet components install beta gke-gcloud-auth-plugin \
        && rm -rf $(find /usr/local/gcloud -regex ".*/__pycache__") \
        && rm -rf /usr/local/gcloud/google-cloud-sdk/.install/.backup
    SAVE ARTIFACT /usr/local/gcloud

awsvault:
    ARG arch
    ARG AWSVAULT
    FROM +asdf --arch=${arch}
    RUN echo "aws-vault ${AWSVAULT}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add aws-vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

skaffold:
    ARG arch
    ARG SKAFFOLD
    FROM +asdf --arch=${arch}
    RUN echo "skaffold ${SKAFFOLD}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add skaffold'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

shell-operator:
    FROM flant/shell-operator:latest
    WORKDIR /
    RUN tar cvfz sf.tar.gz shell* frameworks
    SAVE ARTIFACT sf.tar.gz

rerun-process-wrapper:
    FROM alpine/git
    RUN git clone https://github.com/tilt-dev/rerun-process-wrapper
    SAVE ARTIFACT rerun-process-wrapper/*.sh

grpcurl:
    ARG arch
    ARG GRPCURL
    FROM +asdf --arch=${arch}
    RUN echo "grpcurl ${GRPCURL}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add grpcurl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

rust:
    ARG arch
    ARG RUST
    FROM +asdf --arch=${arch}
    RUN echo "rust ${RUST}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add rust'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kubectl:
    ARG arch
    ARG KUBECTL
    FROM +asdf --arch=${arch}
    RUN echo "kubectl ${KUBECTL}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kubectl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

krew:
    ARG arch
    ARG KREW
    FROM +kubectl --arch=${arch}
    RUN echo "krew ${KREW}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add krew'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ns
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ctx
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install stern
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT --symlink-no-follow .asdf

k9s:
    ARG arch
    ARG K9S
    FROM +asdf --arch=${arch}
    RUN echo k9s ${K9S} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k9s'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kustomize:
    ARG arch
    ARG KUSTOMIZE
    FROM +asdf --arch=${arch}
    RUN echo kustomize ${KUSTOMIZE} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kustomize'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

helm:
    ARG arch
    ARG HELM
    FROM +asdf --arch=${arch}
    RUN echo helm ${HELM} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add helm'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

k3sup:
    ARG arch
    ARG K3SUP
    FROM +asdf --arch=${arch}
    RUN echo k3sup ${K3SUP} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k3sup'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

packer:
    ARG arch
    ARG PACKER
    FROM +asdf --arch=${arch}
    RUN echo packer ${PACKER} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add packer'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

k3d-asdf:
    ARG arch
    ARG K3D
    FROM +asdf --arch=${arch}
    RUN echo k3d ${K3D} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k3d'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

teleport:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret TELEPORT echo teleport-ent ${TELEPORT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add teleport-ent'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

nomad:
    ARG arch
    ARG NOMAD
    FROM +asdf --arch=${arch}
    RUN echo nomad ${NOMAD} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add nomad'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

vault:
    ARG arch
    ARG VAULT
    FROM +asdf --arch=${arch}
    RUN echo vault ${VAULT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

consul:
    ARG arch
    ARG CONSUL
    FROM +asdf --arch=${arch}
    RUN echo consul ${CONSUL} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add consul'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

boundary:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret BOUNDARY echo boundary ${BOUNDARY} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add boundary'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

cloudflared:
    ARG arch
    ARG CLOUDFLARED
    FROM +asdf --arch=${arch}
    RUN echo cloudflared ${CLOUDFLARED} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add cloudflared'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

shell:
    ARG arch
    ARG SHELLCHECK
    ARG SHFMT
    FROM +asdf --arch=${arch}
    RUN echo shellcheck ${SHELLCHECK} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shellcheck'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN echo shfmt ${SHFMT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shfmt'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

terraform:
    ARG arch
    ARG TERRAFORM
    FROM +asdf --arch=${arch}
    RUN echo terraform ${TERRAFORM} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add terraform'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

golang:
    ARG arch
    ARG GOLANG
    FROM +asdf --arch=${arch}
    RUN echo golang ${GOLANG} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add golang'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint

gotools:
    ARG arch
    FROM +golang --arch=${arch}
    ARG GOLANG
    RUN bash -c 'source ~/.asdf/asdf.sh && go install github.com/go-delve/delve/cmd/dlv@latest'
    RUN bash -c 'source ~/.asdf/asdf.sh && go install golang.org/x/tools/gopls@latest'
    RUN bash -c 'source ~/.asdf/asdf.sh && go install honnef.co/go/tools/cmd/staticcheck@latest'
    SAVE ARTIFACT .asdf/installs/golang/${GOLANG}/packages/bin/*

cue-gen:
    ARG arch
    FROM +golang --arch=${arch}
    RUN bash -c 'source ~/.asdf/asdf.sh && go install istio.io/tools/cmd/cue-gen@latest'
    SAVE ARTIFACT ./.asdf/installs/golang/*/packages/bin/cue-gen

buf:
    ARG arch
    ARG BUF
    FROM +asdf --arch=${arch}
    RUN echo buf ${BUF} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add buf'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

nodejs:
    ARG arch
    ARG NODEJS
    ARG NPM
    ARG NBB
    FROM +asdf --arch=${arch}
    RUN echo nodejs ${NODEJS} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add nodejs'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN bash -c 'source ~/.asdf/asdf.sh && npm install -g npm@${NPM}'
    RUN bash -c 'source ~/.asdf/asdf.sh && npm install -g nbb@${NBB}'
    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint

cdktf:
    ARG arch
    ARG CDKTF
    FROM +nodejs --arch=${arch}
    RUN bash -c 'source ~/.asdf/asdf.sh && npm install -g cdktf-cli@${CDKTF}'
    SAVE ARTIFACT .asdf

doctl:
    ARG arch
    ARG DOCTL
    FROM +asdf --arch=${arch}
    RUN echo doctl ${DOCTL} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add doctl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

argo:
    ARG arch
    ARG ARGO
    FROM +asdf --arch=${arch}
    RUN echo argo ${ARGO} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add argo'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

argocd:
    ARG arch
    ARG ARGOCD
    FROM +asdf --arch=${arch}
    RUN echo argocd ${ARGOCD} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add argocd'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

redis:
    ARG arch
    ARG REDIS
    FROM +asdf --arch=${arch}
    USER root
    RUN apt update && apt install -y build-essential
    USER ubuntu
    RUN echo redis ${REDIS} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add redis'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

python:
    ARG arch
    ARG PYTHON
    FROM +asdf --arch=${arch}
    USER root
    RUN echo apt update && apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
    USER ubuntu
    RUN echo python ${PYTHON} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add python'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN bash -c 'source ~/.asdf/asdf.sh && python -m pip install --upgrade pip'
    RUN bash -c 'source ~/.asdf/asdf.sh && pip install pipx && asdf reshim'
    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint

pipx:
    ARG arch
    FROM +python --arch=${arch}
    RUN ~/.asdf/shims/pipx install yq
    RUN ~/.asdf/shims/pipx install pre-commit
    RUN ~/.asdf/shims/pipx install datadog
    RUN ~/.asdf/shims/pipx install httpie
    RUN ~/.asdf/shims/pipx install ggshield
    RUN ~/.asdf/shims/pipx install supervisor
    RUN ~/.asdf/shims/pipx install sigstore
    RUN ~/.asdf/shims/pipx install morgan
    RUN git init
    COPY --chown=ubuntu:ubuntu .pre-commit-config.yaml .
    RUN bash -c 'source ~/.asdf/asdf.sh && /home/ubuntu/.local/bin/pre-commit install'
    RUN bash -c 'source ~/.asdf/asdf.sh && /home/ubuntu/.local/bin/pre-commit run --all'
    SAVE ARTIFACT --symlink-no-follow .local
    SAVE ARTIFACT --symlink-no-follow .cache
    SAVE ARTIFACT --symlink-no-follow .asdf
