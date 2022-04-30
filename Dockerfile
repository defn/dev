ARG IMAGE

FROM ${IMAGE}

USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    wget apt-transport-https software-properties-common \
    openssh-client tzdata locales iputils-ping iproute2 net-tools dnsutils curl wget unzip xz-utils rsync \
    sudo git vim less fzf jo gron jq \
    make docker.io tini \
    python3-pip python3-venv python-is-python3 \
    gpg pass pass-extension-otp git-crypt oathtool libusb-1.0-0 \
    xdg-utils \
    libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev

RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
RUN echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu
RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

ARG APT
RUN echo ${APT} && apt update && apt upgrade -y
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8 \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN rm -f /usr/bin/gs
RUN ln -nfs /usr/bin/git-crypt /usr/local/bin/

RUN ssh -o StrictHostKeyChecking=no git@github.com true || true

USER ubuntu
ENV HOME=/home/ubuntu
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
WORKDIR /home/ubuntu

RUN pip install --user pipx
RUN /home/ubuntu/.local/bin/pipx install --pip-args "keyring_pass" poetry
RUN /home/ubuntu/.local/bin/pipx install watchdog
RUN /home/ubuntu/.local/bin/pipx install 'python-dotenv[cli]'
RUN /home/ubuntu/.local/bin/pipx install yq

RUN sudo add-apt-repository -y ppa:deadsnakes/ppa
RUN sudo apt install -y python3.9 python3.9-distutils
RUN python3.9 -m pip install pipx
RUN python3.9 -m pipx install pantsbuild.pants

RUN git init
RUN /home/ubuntu/.local/bin/pipx install pre-commit
COPY --chown=ubuntu:ubuntu .pre-commit-config.yaml .
RUN /home/ubuntu/.local/bin/pre-commit install
RUN /home/ubuntu/.local/bin/pre-commit run --all

COPY --chown=ubuntu:ubuntu .vim .vim
COPY --chown=ubuntu:ubuntu .vimrc .
RUN echo yes | vim +PlugInstall +qall

COPY --chown=ubuntu:ubuntu . .
RUN git remote rm origin && git remote add origin https://github.com/defn/dev && git fetch && git branch -u origin/main

RUN mkdir -p ~/.docker && echo '{"credsStore": "pass"}' > ~/.docker/config.json

ARG CREDENTIAL_PASS
RUN cd /usr/local/bin && curl -sSL https://github.com/docker/docker-credential-helpers/releases/download/v${CREDENTIAL_PASS}/docker-credential-pass-v${CREDENTIAL_PASS}-amd64.tar.gz \
    | sudo tar xvfz -

ARG POWERLINE
RUN cd /usr/local/bin && sudo curl -sSL -o powerline https://github.com/justjanne/powerline-go/releases/download/v${POWERLINE}/powerline-go-linux-amd64 \
    && sudo chmod 755 powerline

ARG HOF
RUN cd /usr/local/bin && sudo curl -sSL -o hof https://github.com/hofstadter-io/hof/releases/download/v${HOF}/hof_${HOF}_Linux_x86_64 \
    && sudo chmod 755 hof

ARG STEP
RUN curl -sSL -o step.deb https://dl.step.sm/gh-release/cli/gh-release-header/v${STEP}/step-cli_${STEP}_amd64.deb \
    && sudo dpkg -i step.deb && rm -f step.deb

ARG CILIUM
RUN cd /usr/local/bin && curl -sSL https://github.com/cilium/cilium-cli/releases/download/v${CILIUM}/cilium-linux-amd64.tar.gz \
    | sudo tar xvfz -

ARG HUBBLE
RUN cd /usr/local/bin && curl -sSL https://github.com/cilium/hubble/releases/download/v${HUBBLE}/hubble-linux-amd64.tar.gz \
    | sudo tar xzvf -

ARG LINKERD
RUN cd /usr/local/bin && sudo curl -sSL -o linkerd https://github.com/linkerd/linkerd2/releases/download/${LINKERD}/linkerd2-cli-${LINKERD}-linux-amd64 \
    && sudo chmod 755 linkerd

ARG VCLUSTER
RUN cd /usr/local/bin && sudo curl -sSL -o vcluster https://github.com/loft-sh/vcluster/releases/download/v${VCLUSTER}/vcluster-linux-amd64 \
    && sudo chmod 755 vcluster

ARG LOFT
RUN cd /usr/local/bin && sudo curl -sSL -o loft https://github.com/loft-sh/loft/releases/download/v${LOFT}/loft-linux-amd64 \
    && sudo chmod 755 loft

ARG STEAMPIPE
RUN cd /usr/local/bin && curl -sSL https://github.com/turbot/steampipe/releases/download/v${STEAMPIPE}/steampipe_linux_amd64.tar.gz \
    | sudo tar xvfz -

ARG JLESS
RUN (curl -sSL https://github.com/PaulJuliusMartinez/jless/releases/download/v${JLESS}/jless-v${JLESS}-x86_64-unknown-linux-gnu.zip | gunzip -c - > jless) \
    && chmod 755 jless && sudo mv jless /usr/local/bin/

ARG WOODPECKER
RUN cd /usr/local/bin && curl -sSL https://github.com/woodpecker-ci/woodpecker/releases/download/v${WOODPECKER}/woodpecker-agent_linux_amd64.tar.gz | sudo tar xvfz -
RUN cd /usr/local/bin && curl -sSL https://github.com/woodpecker-ci/woodpecker/releases/download/v${WOODPECKER}/woodpecker-cli_linux_amd64.tar.gz | sudo  tar xvfz -

ARG CIRRUS
RUN cd /usr/local/bin && curl -sSL https://github.com/cirruslabs/cirrus-cli/releases/download/v${CIRRUS}/cirrus-linux-amd64.tar.gz | sudo tar xvfz - cirrus

ARG BABASHKA
RUN cd /usr/local/bin && curl -sSL https://github.com/babashka/babashka/releases/download/v${BABASHKA}/babashka-${BABASHKA}-linux-amd64.tar.gz | sudo tar xvfz -

ARG ASDF
COPY --chown=ubuntu:ubuntu .tool-versions .
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${ASDF}
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add shellcheck'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add shfmt'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add cue'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add kubectl'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add krew'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add k9s'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add kustomize'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add helm'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add k3d'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add tilt'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add golang'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add teleport-ent'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add vault'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add consul'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf install'

RUN /home/ubuntu/.asdf/shims/kubectl-krew install ns
RUN /home/ubuntu/.asdf/shims/kubectl-krew install ctx
RUN /home/ubuntu/.asdf/shims/kubectl-krew install stern
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf reshim krew'

RUN ./bin/e /home/ubuntu/.local/bin/pre-commit run --all
