VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link 0.6

IMPORT github.com/defn/cloud/lib:master AS lib

images:
    BUILD +amd64
    BUILD +arm64

updates:
    BUILD +amd64-update
    BUILD +arm64-update

amd64:
    BUILD --platform=linux/amd64 +tower --arch=amd64

arm64:
    BUILD --platform=linux/arm64 +tower --arch=arm64

amd64-update:
    BUILD --platform=linux/amd64 +tower-update --arch=amd64

arm64-update:
    BUILD --platform=linux/arm64 +tower-update --arch=arm64

root:
    ARG arch

    FROM ubuntu:20.04

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
        build-essential make tini python3-pip entr \
        gpg pass pass-extension-otp git-crypt oathtool libusb-1.0-0 \
        xdg-utils figlet lolcat socat netcat-openbsd groff \
        screen htop

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

    COPY etc/daemon.json /etc/docker/daemon.json

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
    SAVE IMAGE --cache-hint 

tower-update:
    ARG arch
    ARG repo=localhost:5000/

    FROM ${repo}defn/dev:tower

    RUN ssh -o StrictHostKeyChecking=no git@github.com true || true

    COPY --chown=ubuntu:ubuntu --dir .vim .
    COPY --chown=ubuntu:ubuntu .vimrc .
    RUN echo yes | vim +PlugInstall +qall

    COPY --dir --chown=ubuntu:ubuntu . .
    COPY --chown=ubuntu:ubuntu etc/config.json .docker/config.json
    RUN git clean -ffd

    SAVE IMAGE --push ${repo}defn/dev

tower:
    ARG repo=localhost:5000/

    ARG arch
    ARG SKAFFOLD
    ARG CDKTF
    ARG NODEJS
    ARG NPM
    ARG KUMA
    ARG POWERLINE
    ARG CILIUM
    ARG HUBBLE
    ARG LINKERD
    ARG VCLUSTER
    ARG LOFT
    ARG GH
    ARG EARTHLY
    ARG K3D
    ARG CUE
    ARG STEP

    ARG AWSVAULT
    ARG PYTHON
    ARG KREW
    ARG HOF
    ARG TILT
    ARG SHELLCHECK
    ARG SHFMT
    ARG K9S
    ARG KUSTOMIZE
    ARG HELM
    ARG VAULT
    ARG CONSUL
    ARG CLOUDFLARED
    ARG TERRAFORM
    ARG ARGO
    ARG ARGOCD

    FROM +root --arch=${arch}

    USER ubuntu
    WORKDIR /home/ubuntu

    ENV HOME=/home/ubuntu

    # arch
    COPY --chown=ubuntu:ubuntu (+powerline/* --arch=${arch} --version=${POWERLINE}) /usr/local/bin
    COPY --chown=ubuntu:ubuntu (+cilium/* --arch=${arch} --version=${CILIUM}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+hubble/* --arch=${arch} --version=${HUBBLE}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+linkerd/* --arch=${arch} --version=${LINKERD}) /usr/local/bin
    COPY --chown=ubuntu:ubuntu (+vcluster/* --arch=${arch} --version=${VCLUSTER}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+loft/* --arch=${arch} --version=${LOFT}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+gh/* --arch=${arch} --version=${GH}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+earthly/* --arch=${arch} --version=${EARTHLY}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+k3d/* --arch=${arch} --version=${K3D}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+cue/* --arch=${arch} --version=${CUE}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+step/* --arch=${arch} --version=${STEP}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+kuma/* --arch=${arch} --version=${KUMA}) /usr/local/bin/

    COPY --chown=ubuntu:ubuntu --dir (+shell/* --arch=${arch} --version_shellcheck=${SHELLCHECK} --version_shfmt=${SHFMT}) ./
    COPY --chown=ubuntu:ubuntu --dir (+k9s/* --arch=${arch} --version=${K9S}) ./
    COPY --chown=ubuntu:ubuntu --dir (+kustomize/* --arch=${arch} --version=${KUSTOMIZE}) ./
    COPY --chown=ubuntu:ubuntu --dir --symlink-no-follow (+krew/* --arch=${arch} --version=${KREW}) ./
    COPY --chown=ubuntu:ubuntu --dir (+helm/* --arch=${arch} --version=${HELM}) ./
    COPY --chown=ubuntu:ubuntu --dir (+vault/* --arch=${arch} --version=${VAULT}) ./
    COPY --chown=ubuntu:ubuntu --dir (+consul/* --arch=${arch} --version=${CONSUL}) ./
    COPY --chown=ubuntu:ubuntu --dir (+cloudflared/* --arch=${arch} --version=${CLOUDFLARED}) ./
    COPY --chown=ubuntu:ubuntu --dir (+terraform/* --arch=${arch} --version=${TERRAFORM}) ./
    COPY --chown=ubuntu:ubuntu --dir (+skaffold/* --arch=${arch} --version=${SKAFFOLD}) ./
    COPY --chown=ubuntu:ubuntu --dir (+awsvault/* --arch=${arch} --version=${AWSVAULT}) ./
    COPY --chown=ubuntu:ubuntu --dir (+argo/* --arch=${arch} --version=${ARGO}) ./
    COPY --chown=ubuntu:ubuntu --dir (+argocd/* --arch=${arch} --version=${ARGOCD}) ./

    COPY --chown=ubuntu:ubuntu --dir (+cdktf/* --arch=${arch} --version=${CDKTF} --version_nodejs=${NODEJS}) ./

    COPY --chown=ubuntu:ubuntu --dir (+python/* --arch=${arch} --version=${PYTHON}) ./
    COPY --chown=ubuntu:ubuntu --dir --symlink-no-follow (+pipx/* --arch=${arch} --version_python=${PYTHON}) ./

    # relies on qemu
    COPY --chown=ubuntu:ubuntu (+credentialPass/* --arch=amd64 --version=${CREDENTIAL_PASS}) /usr/local/bin/

    # arch2: hof, tilt
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu (+hof/* --arch=${arch} --arch2=${arch} --version=${HOF}) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+tilt/* --arch=${arch} --arch2=${arch} --version=${TILT}) /usr/local/bin/
    ELSE
        COPY --chown=ubuntu:ubuntu (+hof/* --arch=${arch} --arch2=x86_64 --version=${HOF}) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+tilt/* --arch=${arch} --arch2=x86_64 --version=${TILT}) /usr/local/bin/
    END

    # gcloud
    COPY --chown=ubuntu:ubuntu --dir (+gcloud/gcloud --arch=${arch}) /usr/local/

    # arch3: awscli
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu --dir (+awscli/aws-cli --arch=${arch} --arch3=aarch64) /usr/local/
    ELSE
        COPY --chown=ubuntu:ubuntu --dir (+awscli/aws-cli --arch=${arch} --arch3=x86_64) /usr/local/
    END

    ENTRYPOINT ["/usr/bin/tini", "--"]

    SAVE IMAGE --push ${repo}defn/dev:tower

tools:
    FROM ubuntu:20.04

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

    RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            apt-transport-https software-properties-common tzdata locales git gpg gpg-agent unzip xz-utils wget curl
    SAVE IMAGE --cache-hint 

asdf:
    ARG arch
    ARG version_asdf=0.10.1
    FROM +tools --arch=${arch}
    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
    RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu
    USER ubuntu
    WORKDIR /home/ubuntu
    RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${version_asdf}
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint 

# arch3
awscli:
    ARG arch
    ARG arch3
    FROM +tools --arch=${arch}
    RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch3}.zip" -o "awscliv2.zip"
    RUN unzip awscliv2.zip
    RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/aws-cli/bin
    SAVE ARTIFACT /usr/local/aws-cli
    SAVE IMAGE --cache-hint 

# arch2
hof:
    ARG arch
    ARG arch2
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o hof https://github.com/hofstadter-io/hof/releases/download/v${version}/hof_${version}_Linux_${arch2} && chmod 755 hof
    SAVE ARTIFACT hof

jless:
    ARG arch
    ARG arch2
    FROM +tools --arch=${arch}
    RUN --secret JLESS (curl -sSL https://github.com/PaulJuliusMartinez/jless/releases/download/v${JLESS}/jless-v${JLESS}-${arch2}-unknown-linux-gnu.zip | gunzip -c - > jless) && chmod 755 jless
    SAVE ARTIFACT jless

flyctl:
    ARG arch
    ARG arch2
    FROM +tools --arch=${arch}
    RUN --secret FLYCTL curl -sSL https://github.com/superfly/flyctl/releases/download/v${FLYCTL}/flyctl_${FLYCTL}_Linux_${arch2}.tar.gz | tar xvfz -
    SAVE ARTIFACT flyctl

difft:
    ARG arch
    ARG arch2
    FROM +tools --arch=${arch}
    RUN --secret DIFFT curl -sSL https://github.com/Wilfred/difftastic/releases/download/${DIFFT}/difft-${arch2}-unknown-linux-gnu.tar.gz | tar xvfz -
    SAVE ARTIFACT difft

tilt:
    ARG arch
    ARG arch2
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/tilt-dev/tilt/releases/download/v${version}/tilt.${version}.linux.${arch2}.tar.gz | tar xvfz -
    SAVE ARTIFACT tilt

# arch
credentialPass:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/docker/docker-credential-helpers/releases/download/v${version}/docker-credential-pass-v${version}-${arch}.tar.gz | tar xvfz - && chmod 755 docker-credential-pass
    SAVE ARTIFACT docker-credential-pass

powerline:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o powerline https://github.com/justjanne/powerline-go/releases/download/v${version}/powerline-go-linux-${arch} && chmod 755 powerline
    SAVE ARTIFACT powerline

step:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN echo 1
    RUN curl -sSL https://github.com/smallstep/cli/releases/download/v${version}/step_linux_${version}_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT */bin/step

cilium:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cilium/cilium-cli/releases/download/v${version}/cilium-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cilium

hubble:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cilium/hubble/releases/download/v${version}/hubble-linux-${arch}.tar.gz | tar xzvf -
    SAVE ARTIFACT hubble

linkerd:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o linkerd https://github.com/linkerd/linkerd2/releases/download/${version}/linkerd2-cli-${version}-linux-${arch} && chmod 755 linkerd
    SAVE ARTIFACT linkerd

vcluster:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o vcluster https://github.com/loft-sh/vcluster/releases/download/v${vcluster}/vcluster-linux-${arch} && chmod 755 vcluster
    SAVE ARTIFACT vcluster

loft:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o loft https://github.com/loft-sh/loft/releases/download/v${version}/loft-linux-${arch} && chmod 755 loft
    SAVE ARTIFACT loft

steampipe:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret STEAMPIPE curl -sSL https://github.com/turbot/steampipe/releases/download/v${STEAMPIPE}/steampipe_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT steampipe

gh:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cli/cli/releases/download/v${version}/gh_${version}_linux_${arch}.tar.gz | tar xvfz - --wildcards '*/bin/gh' && mv */bin/gh .
    SAVE ARTIFACT gh

earthly:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o earthly https://github.com/earthly/earthly/releases/download/v${version}/earthly-linux-${arch} && chmod 755 earthly
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

hlb:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret HLB curl -sSL -o hlb https://github.com/openllb/hlb/releases/download/v${HLB}/hlb-linux-${arch} && chmod 755 hlb
    SAVE ARTIFACT hlb

litestream:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret LITESTREAM curl -sSL https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM}/litestream-v${LITESTREAM}-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT litestream

cue:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cue-lang/cue/releases/download/v${version}/cue_v${version}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cue

kuma:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL https://download.konghq.com/mesh-alpine/kuma-${version}-ubuntu-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT */bin/*

k3d:
    ARG arch
    ARG version
    FROM +tools --arch=${arch}
    RUN curl -sSL -o k3d https://github.com/k3d-io/k3d/releases/download/v${version}/k3d-linux-${arch} && chmod 755 k3d
    SAVE ARTIFACT k3d

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
    SAVE IMAGE --cache-hint 

awsvault:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo "aws-vault ${version}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add aws-vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

skaffold:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo "skaffold ${version}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add skaffold'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kubectl:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo "kubectl ${version}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kubectl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

krew:
    ARG arch
    ARG version
    FROM +kubectl --arch=${arch}
    RUN echo "krew ${version}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add krew'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ns
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ctx
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install stern
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT --symlink-no-follow .asdf

k9s:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo k9s ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k9s'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kustomize:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo kustomize ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kustomize'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

helm:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo helm ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add helm'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

k3sup:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret K3SUP echo k3sup ${K3SUP} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k3sup'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

teleport:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret TELEPORT echo teleport-ent ${TELEPORT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add teleport-ent'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

vault:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo vault ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

consul:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo consul ${version} >> .tool-versions
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
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo cloudflared ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add cloudflared'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

shell:
    ARG arch
    ARG version_shellcheck
    ARG version_shfmt
    FROM +asdf --arch=${arch}
    RUN echo shellcheck ${version_shellcheck} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shellcheck'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN echo shfmt ${version_shfmt} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shfmt'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

terraform:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo terraform ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add terraform'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

nodejs:
    ARG arch
    ARG version
    ROM +asdf --arch=${arch}
    RUN echo nodejs ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add nodejs'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN bash -c 'source ~/.asdf/asdf.sh && npm install -g npm@latest'
    SAVE ARTIFACT .asdf

cdktf:
    ARG arch
    ARG version
    ARG version_nodejs
    ARG version_npm
    FROM +nodejs --arch=${arch} --version=${version_nodejs} --version_npm=${version_npm}
    RUN bash -c 'source ~/.asdf/asdf.sh && npm install -g cdktf-cli@${version}'
    SAVE ARTIFACT .asdf

doctl:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret DOCTL echo doctl ${DOCTL} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add doctl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

argo:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo argo ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add argo'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

argocd:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    RUN echo argocd ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add argocd'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

python:
    ARG arch
    ARG version
    FROM +asdf --arch=${arch}
    USER root
    RUN apt update && apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
    USER ubuntu
    RUN echo python ${version} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add python'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN bash -c 'source ~/.asdf/asdf.sh && python -m pip install --upgrade pip'
    RUN bash -c 'source ~/.asdf/asdf.sh && pip install pipx && asdf reshim'
    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint 

pipx:
    ARG arch
    ARG version_python
    FROM +python --arch=${arch} --version=${version_python}
    RUN ~/.asdf/shims/pipx install pycco
    RUN ~/.asdf/shims/pipx install yq
    RUN ~/.asdf/shims/pipx install watchdog
    RUN ~/.asdf/shims/pipx install "python-dotenv[cli]"
    RUN ~/.asdf/shims/pipx install twine
    RUN ~/.asdf/shims/pipx install pre-commit
    RUN ~/.asdf/shims/pipx install black
    RUN git init
    COPY --chown=ubuntu:ubuntu .pre-commit-config.yaml .
    RUN bash -c 'source ~/.asdf/asdf.sh && /home/ubuntu/.local/bin/pre-commit install'
    RUN bash -c 'source ~/.asdf/asdf.sh && /home/ubuntu/.local/bin/pre-commit run --all'
    SAVE ARTIFACT --symlink-no-follow .asdf
    SAVE ARTIFACT --symlink-no-follow .local
    SAVE ARTIFACT --symlink-no-follow .cache
    SAVE IMAGE --cache-hint 
