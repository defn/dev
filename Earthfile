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
        build-essential make tini python3-pip \
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

    #RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
    #RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

    RUN mkdir /run/sshd

    RUN chown -R ubuntu:ubuntu /home/ubuntu
    RUN chmod u+s /usr/bin/sudo

TOWER:
    COMMAND

    ARG arch

    # arch
    COPY --chown=ubuntu:ubuntu (+powerline/* --arch=${arch}) /usr/local/bin
    COPY --chown=ubuntu:ubuntu (+cilium/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+hubble/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+linkerd/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+vcluster/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+loft/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+steampipe/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+gh/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+earthly/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+buildkite/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+bk/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+hlb/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+litestream/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+k3d/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+cue/* --arch=${arch}) /usr/local/bin/
    COPY --chown=ubuntu:ubuntu (+step/* --arch=${arch}) /usr/local/bin/

    COPY --chown=ubuntu:ubuntu --dir (+shell/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+k9s/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+kustomize/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+helm/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+k3sup/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+teleport/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+vault/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+consul/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+boundary/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+cloudflared/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+terraform/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+cdktf/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+skaffold/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+awsvault/* --arch=${arch}) ./

    COPY --chown=ubuntu:ubuntu --dir (+python/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir --symlink-no-follow (+pipx/* --arch=${arch}) ./

    COPY --chown=ubuntu:ubuntu --dir --symlink-no-follow (+krew/* --arch=${arch}) ./

    COPY --chown=ubuntu:ubuntu --dir (+gcloud/gcloud --arch=${arch}) /usr/local/

    # arch3
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu --dir (+awscli/aws-cli --arch=${arch} --arch3=aarch64) /usr/local/
    ELSE
        COPY --chown=ubuntu:ubuntu --dir (+awscli/aws-cli --arch=${arch} --arch3=x86_64) /usr/local/
    END

    # arch2
    IF [ ${arch} = "arm64" ]
        COPY --chown=ubuntu:ubuntu (+hof/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+flyctl/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+tilt/* --arch=${arch} --arch2=${arch}) /usr/local/bin/
    ELSE
        COPY --chown=ubuntu:ubuntu (+hof/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+flyctl/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
        COPY --chown=ubuntu:ubuntu (+tilt/* --arch=${arch} --arch2=x86_64) /usr/local/bin/
    END

    COPY --chown=ubuntu:ubuntu --dir (+argo/* --arch=${arch}) ./
    COPY --chown=ubuntu:ubuntu --dir (+argocd/* --arch=${arch}) ./

    # amd64
    IF [ "${arch}" = "amd64" ]
        COPY --chown=ubuntu:ubuntu (+credentialPass/* --arch=${arch}) /usr/local/bin/
    END

    # TODO move to root 
    RUN sudo apt update && sudo apt install -y entr

    ENTRYPOINT ["/usr/bin/tini", "--"]

tower-update:
    ARG arch
    FROM defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN git clean -ffd
    SAVE IMAGE --push defn/dev

tower:
    ARG arch

    FROM +root --arch=${arch}

    USER ubuntu
    WORKDIR /home/ubuntu

    ENV HOME=/home/ubuntu

    RUN sudo uname -a

    COPY --chown=ubuntu:ubuntu --dir .vim .
    COPY --chown=ubuntu:ubuntu .vimrc .
    RUN echo yes | vim +PlugInstall +qall

    RUN mkdir -p ~/.docker && echo '{"credsStore": "pass"}' > ~/.docker/config.json

    RUN ssh -o StrictHostKeyChecking=no git@github.com true || true

    DO +TOWER --arch=${arch}

    COPY --dir --chown=ubuntu:ubuntu . .

    SAVE IMAGE --push defn/dev

tools:
    FROM ubuntu:20.04

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

    RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            apt-transport-https software-properties-common tzdata locales git gpg gpg-agent unzip xz-utils wget curl

asdf:
    ARG arch
    FROM +tools --arch=${arch}
    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
    RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu
    USER ubuntu
    WORKDIR /home/ubuntu
    RUN --secret ASDF git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${ASDF}
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT .asdf

# arch3
awscli:
    ARG arch
    ARG arch3
    FROM +tools --arch=${arch}
    RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch3}.zip" -o "awscliv2.zip"
    RUN unzip awscliv2.zip
    RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/aws-cli/bin
    SAVE ARTIFACT /usr/local/aws-cli

# arch2
hof:
    ARG arch
    ARG arch2
    FROM +tools --arch=${arch}
    RUN --secret HOF curl -sSL -o hof https://github.com/hofstadter-io/hof/releases/download/v${HOF}/hof_${HOF}_Linux_${arch2} && chmod 755 hof
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
    FROM +tools --arch=${arch}
    RUN --secret TILT curl -sSL https://github.com/tilt-dev/tilt/releases/download/v${TILT}/tilt.${TILT}.linux.${arch2}.tar.gz | tar xvfz -
    SAVE ARTIFACT tilt

# arch
credentialPass:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret CREDENTIAL_PASS curl -sSL https://github.com/docker/docker-credential-helpers/releases/download/v${CREDENTIAL_PASS}/docker-credential-pass-v${CREDENTIAL_PASS}-${arch}.tar.gz | tar xvfz - && chmod 755 docker-credential-pass
    SAVE ARTIFACT docker-credential-pass

powerline:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret POWERLINE curl -sSL -o powerline https://github.com/justjanne/powerline-go/releases/download/v${POWERLINE}/powerline-go-linux-${arch} && chmod 755 powerline
    SAVE ARTIFACT powerline

step:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret STEP curl -sSL -https://github.com/smallstep/cli/releases/download/v${STEP}/step_linux_${STEP}_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT */bin/step

cilium:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret CILIUM curl -sSL https://github.com/cilium/cilium-cli/releases/download/v${CILIUM}/cilium-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cilium

hubble:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret HUBBLE curl -sSL https://github.com/cilium/hubble/releases/download/v${HUBBLE}/hubble-linux-${arch}.tar.gz | tar xzvf -
    SAVE ARTIFACT hubble

linkerd:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret LINKERD curl -sSL -o linkerd https://github.com/linkerd/linkerd2/releases/download/${LINKERD}/linkerd2-cli-${LINKERD}-linux-${arch} && chmod 755 linkerd
    SAVE ARTIFACT linkerd

vcluster:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret VCLUSTER curl -sSL -o vcluster https://github.com/loft-sh/vcluster/releases/download/v${VCLUSTER}/vcluster-linux-${arch} && chmod 755 vcluster
    SAVE ARTIFACT vcluster

loft:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret LOFT curl -sSL -o loft https://github.com/loft-sh/loft/releases/download/v${LOFT}/loft-linux-${arch} && chmod 755 loft
    SAVE ARTIFACT loft

steampipe:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret STEAMPIPE curl -sSL https://github.com/turbot/steampipe/releases/download/v${STEAMPIPE}/steampipe_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT steampipe

gh:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret GH curl -sSL https://github.com/cli/cli/releases/download/v${GH}/gh_${GH}_linux_${arch}.tar.gz | tar xvfz - --wildcards '*/bin/gh' && mv */bin/gh .
    SAVE ARTIFACT gh

earthly:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret EARTHLY curl -sSL -o earthly https://github.com/earthly/earthly/releases/download/v${EARTHLY}/earthly-linux-${arch} && chmod 755 earthly
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
    FROM +tools --arch=${arch}
    RUN --secret CUE curl -sSL https://github.com/cue-lang/cue/releases/download/v${CUE}/cue_v${CUE}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cue

k3d:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret K3D curl -sSL -o k3d https://github.com/k3d-io/k3d/releases/download/v${K3D}/k3d-linux-${arch} && chmod 755 k3d
    SAVE ARTIFACT k3d

gcloud:
    ARG arch
    FROM +tools --arch=${arch}
    RUN curl https://sdk.cloud.google.com > install.sh
    RUN bash install.sh --disable-prompts --install-dir=/usr/local/gcloud
    RUN /usr/local/gcloud/google-cloud-sdk/bin/gcloud --quiet components install beta
    RUN /usr/local/gcloud/google-cloud-sdk/bin/gcloud --quiet components install gke-gcloud-auth-plugin
    RUN rm -rf /usr/local/gcloud/google-cloud-sdk/.install
    SAVE ARTIFACT /usr/local/gcloud

awsvault:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret AWSVAULT echo "aws-vault ${AWSVAULT}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add aws-vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

skaffold:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret SKAFFOLD echo "skaffold ${SKAFFOLD}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add skaffold'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kubectl:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret KUBECTL echo "kubectl ${KUBECTL}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kubectl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

krew:
    ARG arch
    FROM +kubectl --arch=${arch}
    RUN --secret KREW echo "krew ${KREW}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add krew'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ns
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ctx
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install stern
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT --symlink-no-follow .asdf

k9s:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret K9S echo k9s ${K9S} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k9s'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kustomize:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret KUSTOMIZE echo kustomize ${KUSTOMIZE} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kustomize'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

helm:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret HELM echo helm ${HELM} >> .tool-versions
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
    FROM +asdf --arch=${arch}
    RUN --secret VAULT echo vault ${VAULT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

consul:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret CONSUL echo consul ${CONSUL} >> .tool-versions
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
    FROM +asdf --arch=${arch}
    RUN --secret CLOUDFLARED echo cloudflared ${CLOUDFLARED} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add cloudflared'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

shell:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret SHELLCHECK echo shellcheck ${SHELLCHECK} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shellcheck'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN --secret SHFMT echo shfmt ${SHFMT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shfmt'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

terraform:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret TERRAFORM echo terraform ${TERRAFORM} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add terraform'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

nodejs:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret NODEJS echo nodejs ${NODEJS} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add nodejs'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN --secret NPM bash -c 'source ~/.asdf/asdf.sh && npm install -g npm@${NPM}'
    SAVE ARTIFACT .asdf

cdktf:
    ARG arch
    FROM +nodejs --arch=${arch}
    RUN --secret CDKTF bash -c 'source ~/.asdf/asdf.sh && npm install -g cdktf-cli@${CDKTF}'
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
    FROM +asdf --arch=${arch}
    RUN --secret ARGO echo argo ${ARGO} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add argo'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

argocd:
    ARG arch
    FROM +asdf --arch=${arch}
    RUN --secret ARGOCD echo argocd ${ARGOCD} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add argocd'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

python:
    ARG arch
    FROM +asdf --arch=${arch}
    USER root
    RUN apt update && apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
    USER ubuntu
    RUN --secret PYTHON echo python ${PYTHON} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add python'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN bash -c 'source ~/.asdf/asdf.sh && python -m pip install --upgrade pip'
    RUN bash -c 'source ~/.asdf/asdf.sh && pip install pipx && asdf reshim'
    SAVE ARTIFACT .asdf

pipx:
    ARG arch
    FROM +python --arch=${arch}
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
