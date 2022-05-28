VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link 0.6

IMPORT github.com/defn/cloud/lib:master AS lib

warm:
    FROM lib+platform
    RUN --no-cache --secret hello echo ${hello}

images:
    BUILD +root
    BUILD +tower
    BUILD +ci

root:
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
        make tini \
        gpg pass pass-extension-otp git-crypt oathtool libusb-1.0-0 \
        xdg-utils figlet lolcat socat netcat-openbsd \
        screen htop \
        python3-pip

    RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
        && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
        && apt-get update \
        && apt install -y tailscale

    RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
        && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | tee /etc/apt/sources.list.d/docker.list \
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

    SAVE IMAGE --push registry.fly.io/defn:dev-root

TOWER:
    COMMAND

    COPY --chown=ubuntu:ubuntu +credentialPass/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +powerline/* /usr/local/bin
    COPY --chown=ubuntu:ubuntu +hof/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +step/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +cilium/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +hubble/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +linkerd/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +vcluster/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +loft/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +steampipe/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +jless/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +gh/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +flyctl/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +earthly/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +buildkite/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +bk/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +hlb/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +difft/* /usr/local/bin/
    COPY --chown=ubuntu:ubuntu +litestream/* /usr/local/bin/

    COPY --chown=ubuntu:ubuntu --dir +shell/* ./
    COPY --chown=ubuntu:ubuntu --dir +cue/* ./
    COPY --chown=ubuntu:ubuntu --dir +k9s/* ./
    COPY --chown=ubuntu:ubuntu --dir +kustomize/* ./
    COPY --chown=ubuntu:ubuntu --dir +helm/* ./
    COPY --chown=ubuntu:ubuntu --dir +k3d/* ./
    COPY --chown=ubuntu:ubuntu --dir +k3sup/* ./
    COPY --chown=ubuntu:ubuntu --dir +tilt/* ./
    COPY --chown=ubuntu:ubuntu --dir +teleport/* ./
    COPY --chown=ubuntu:ubuntu --dir +vault/* ./
    COPY --chown=ubuntu:ubuntu --dir +consul/* ./
    COPY --chown=ubuntu:ubuntu --dir +cloudflared/* ./
    COPY --chown=ubuntu:ubuntu --dir +terraform/* ./
    COPY --chown=ubuntu:ubuntu --dir +cdktf/* ./
    COPY --chown=ubuntu:ubuntu --dir +doctl/* ./
    COPY --chown=ubuntu:ubuntu --dir +python/* ./
    COPY --chown=ubuntu:ubuntu --dir +kubectl/* ./

tower:
    FROM +root

    USER ubuntu
    WORKDIR /home/ubuntu

    ENV HOME=/home/ubuntu

    RUN sudo uname -a

    COPY --chown=ubuntu:ubuntu --dir .vim .
    COPY --chown=ubuntu:ubuntu .vimrc .
    RUN echo yes | vim +PlugInstall +qall

    RUN mkdir -p ~/.docker && echo '{"credsStore": "pass"}' > ~/.docker/config.json

    RUN ssh -o StrictHostKeyChecking=no git@github.com true || true

    DO +TOWER

    COPY --chown=ubuntu:ubuntu bin/e bin/e
    COPY --chown=ubuntu:ubuntu .bash_profile .
    COPY --chown=ubuntu:ubuntu .bashrc .

    RUN /usr/bin/pip install pantsbuild.pants

    RUN --secret PYTHON echo python ${PYTHON} >> .tool-versions
    RUN ~/bin/e pipx install pycco
    RUN ~/bin/e pipx install yq
    RUN ~/bin/e pipx install watchdog
    RUN ~/bin/e pipx install "python-dotenv[cli]"
    RUN ~/bin/e pipx install poetry
    RUN ~/bin/e pipx install twine
    RUN ~/bin/e pipx install pre-commit

    RUN --secret KUBECTL echo kubectl ${KUBECTL} >> .tool-versions
    RUN --secret KREW echo krew ${KREW} >> .tool-versions
    RUN ~/bin/e asdf plugin-add krew
    RUN ~/bin/e asdf install
    RUN ~/bin/e kubectl krew install ns
    RUN ~/bin/e kubectl krew install ctx
    RUN ~/bin/e kubectl krew install stern
    RUN ~/bin/e asdf reshim

    COPY --dir --chown=ubuntu:ubuntu . .

    SAVE IMAGE --push registry.fly.io/defn:dev-tower

ci:
    FROM +tower

    USER root

    SAVE IMAGE --push registry.fly.io/defn:dev-ci

tools:
    FROM ubuntu:20.04

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

    RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            apt-transport-https software-properties-common tzdata locales git gpg gpg-agent unzip xz-utils wget curl

asdf:
    FROM +tools
    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
    RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu
    USER ubuntu
    WORKDIR /home/ubuntu
    RUN --secret ASDF git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${ASDF}
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT .asdf

credentialPass:
    FROM +tools
    RUN --secret CREDENTIAL_PASS curl -sSL https://github.com/docker/docker-credential-helpers/releases/download/v${CREDENTIAL_PASS}/docker-credential-pass-v${CREDENTIAL_PASS}-amd64.tar.gz | tar xvfz - && chmod 755 docker-credential-pass
    SAVE ARTIFACT docker-credential-pass

powerline:
    FROM +tools
    RUN --secret POWERLINE curl -sSL -o powerline https://github.com/justjanne/powerline-go/releases/download/v${POWERLINE}/powerline-go-linux-amd64 && chmod 755 powerline
    SAVE ARTIFACT powerline

hof:
    FROM +tools
    RUN --secret HOF curl -sSL -o hof https://github.com/hofstadter-io/hof/releases/download/v${HOF}/hof_${HOF}_Linux_x86_64 && chmod 755 hof
    SAVE ARTIFACT hof

step:
    FROM +tools
    RUN --secret STEP curl -sSL -o step.deb https://dl.step.sm/gh-release/cli/gh-release-header/v${STEP}/step-cli_${STEP}_amd64.deb && dpkg -i step.deb
    RUN cp /usr/bin/step* .
    SAVE ARTIFACT step
    SAVE ARTIFACT step-cli

cilium:
    FROM +tools
    RUN --secret CILIUM curl -sSL https://github.com/cilium/cilium-cli/releases/download/v${CILIUM}/cilium-linux-amd64.tar.gz | tar xvfz -
    SAVE ARTIFACT cilium

hubble:
    FROM +tools
    RUN --secret HUBBLE curl -sSL https://github.com/cilium/hubble/releases/download/v${HUBBLE}/hubble-linux-amd64.tar.gz | tar xzvf -
    SAVE ARTIFACT hubble

linkerd:
    FROM +tools
    RUN --secret LINKERD curl -sSL -o linkerd https://github.com/linkerd/linkerd2/releases/download/${LINKERD}/linkerd2-cli-${LINKERD}-linux-amd64 && chmod 755 linkerd
    SAVE ARTIFACT linkerd

vcluster:
    FROM +tools
    RUN --secret VCLUSTER curl -sSL -o vcluster https://github.com/loft-sh/vcluster/releases/download/v${VCLUSTER}/vcluster-linux-amd64 && chmod 755 vcluster
    SAVE ARTIFACT vcluster

loft:
    FROM +tools
    RUN --secret LOFT curl -sSL -o loft https://github.com/loft-sh/loft/releases/download/v${LOFT}/loft-linux-amd64 && chmod 755 loft
    SAVE ARTIFACT loft

steampipe:
    FROM +tools
    RUN --secret STEAMPIPE curl -sSL https://github.com/turbot/steampipe/releases/download/v${STEAMPIPE}/steampipe_linux_amd64.tar.gz | tar xvfz -
    SAVE ARTIFACT steampipe

jless:
    FROM +tools
    RUN --secret JLESS (curl -sSL https://github.com/PaulJuliusMartinez/jless/releases/download/v${JLESS}/jless-v${JLESS}-x86_64-unknown-linux-gnu.zip | gunzip -c - > jless) && chmod 755 jless
    SAVE ARTIFACT jless

gh:
    FROM +tools
    RUN --secret GH curl -sSL https://github.com/cli/cli/releases/download/v${GH}/gh_${GH}_linux_amd64.tar.gz | tar xvfz - --wildcards '*/bin/gh' && mv */bin/gh .
    SAVE ARTIFACT gh

flyctl:
    FROM +tools
    RUN --secret FLYCTL echo curl -sSL https://github.com/superfly/flyctl/releases/download/v${FLYCTL}/flyctl_${FLYCTL}_Linux_x86_64.tar.gz
    RUN --secret FLYCTL curl -sSL https://github.com/superfly/flyctl/releases/download/v${FLYCTL}/flyctl_${FLYCTL}_Linux_x86_64.tar.gz | tar xvfz -
    SAVE ARTIFACT flyctl

earthly:
    FROM +tools
    RUN --secret EARTHLY curl -sSL -o earthly https://github.com/earthly/earthly/releases/download/v${EARTHLY}/earthly-linux-amd64 && chmod 755 earthly
    SAVE ARTIFACT earthly

buildkite:
    FROM +tools
    RUN --secret BUILDKITE curl -sSL https://github.com/buildkite/agent/releases/download/v${BUILDKITE}/buildkite-agent-linux-amd64-${BUILDKITE}.tar.gz | tar xvfz -
    SAVE ARTIFACT buildkite-agent

bk:
    FROM +tools
    RUN --secret BKCLI curl -sSL -o bk https://github.com/buildkite/cli/releases/download/v${BKCLI}/cli-linux-amd64 && chmod 755 bk
    SAVE ARTIFACT bk

hlb:
    FROM +tools
    RUN --secret HLB curl -sSL -o hlb https://github.com/openllb/hlb/releases/download/v${HLB}/hlb-linux-amd64 && chmod 755 hlb
    SAVE ARTIFACT hlb

difft:
    FROM +tools
    RUN --secret DIFFT curl -sSL https://github.com/Wilfred/difftastic/releases/download/${DIFFT}/difft-x86_64-unknown-linux-gnu.tar.gz | tar xvfz -
    SAVE ARTIFACT difft

litestream:
    FROM +tools
    RUN --secret LITESTREAM curl -sSL https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM}/litestream-v${LITESTREAM}-linux-amd64.tar.gz | tar xvfz -
    SAVE ARTIFACT litestream

kubectl:
    FROM +asdf
    RUN --secret KUBECTL echo "kubectl ${KUBECTL}" >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kubectl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

krew:
    FROM +kubectl
    RUN --secret KREW echo "krew ${KREW}" >> .tool-versions
    RUN --no-cache cat .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add krew'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ns
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install ctx
    RUN /home/ubuntu/.asdf/shims/kubectl-krew install stern
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'
    SAVE ARTIFACT .asdf

k9s:
    FROM +asdf
    RUN --secret K9S echo k9s ${K9S} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k9s'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

kustomize:
    FROM +asdf
    RUN --secret KUSTOMIZE echo kustomize ${KUSTOMIZE} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add kustomize'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

helm:
    FROM +asdf
    RUN --secret HELM echo helm ${HELM} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add helm'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

k3d:
    FROM +asdf
    RUN --secret K3D echo k3d ${K3D} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k3d'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

k3sup:
    FROM +asdf
    RUN --secret K3SUP echo k3sup ${K3SUP} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add k3sup'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

tilt:
    FROM +asdf
    RUN --secret TILT echo tilt ${TILT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add tilt'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

teleport:
    FROM +asdf
    RUN --secret TELEPORT echo teleport-ent ${TELEPORT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add teleport-ent'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

vault:
    FROM +asdf
    RUN --secret VAULT echo vault ${VAULT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add vault'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

consul:
    FROM +asdf
    RUN --secret CONSUL echo consul ${CONSUL} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add consul'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

cloudflared:
    FROM +asdf
    RUN --secret CLOUDFLARED echo cloudflared ${CLOUDFLARED} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add cloudflared'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

shell:
    FROM +asdf
    RUN --secret SHELLCHECK echo shellcheck ${SHELLCHECK} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shellcheck'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN --secret SHFMT echo shfmt ${SHFMT} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add shfmt'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

cue:
    FROM +asdf
    RUN --secret CUE echo cue ${CUE} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add cue'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

terraform:
    FROM +asdf
    RUN --secret TERRAFORM echo terraform ${TERRAFORM} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add terraform'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

nodejs:
    FROM +asdf
    RUN --secret NODEJS echo nodejs ${NODEJS} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add nodejs'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN --secret NPM bash -c 'source ~/.asdf/asdf.sh && npm install -g npm@${NPM}'
    SAVE ARTIFACT .asdf

cdktf:
    FROM +nodejs
    RUN --secret CDKTF bash -c 'source ~/.asdf/asdf.sh && npm install -g cdktf-cli@${CDKTF}'
    SAVE ARTIFACT .asdf

doctl:
    FROM +asdf
    RUN --secret DOCTL echo doctl ${DOCTL} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add doctl'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    SAVE ARTIFACT .asdf

python:
    FROM +asdf
    USER root
    RUN apt update && apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
    USER ubuntu
    RUN --secret PYTHON echo python ${PYTHON} >> .tool-versions
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf plugin-add python'
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf install'
    RUN bash -c 'source ~/.asdf/asdf.sh && python -m pip install --upgrade pip'
    RUN bash -c 'source ~/.asdf/asdf.sh && pip install pipx && asdf reshim'
    SAVE ARTIFACT .asdf

precommit:
    FROM +python
    RUN git init
    COPY --chown=ubuntu:ubuntu .pre-commit-config.yaml .
    RUN bash -c 'source ~/.asdf/asdf.sh && pipx install pre-commit'
    RUN bash -c 'source ~/.asdf/asdf.sh && /home/ubuntu/.local/bin/pre-commit install'
    RUN bash -c 'source ~/.asdf/asdf.sh && /home/ubuntu/.local/bin/pre-commit run --all'
    SAVE ARTIFACT .asdf
    SAVE ARTIFACT .local
    SAVE ARTIFACT .cache
