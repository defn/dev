FROM 127.0.0.1:4999/ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y direnv curl xz-utils sudo locales git build-essential rsync pipx
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN groupadd -r --gid 1000 ubuntu && useradd -m -s /bin/bash -g ubuntu --uid 1000 ubuntu

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu

RUN bash -c 'cd ~ && git clone https://github.com/defn/dev dev && mv dev/.git . && rm -rf dev && git reset --hard'
RUN bash -c 'cd ~ && source ~/.bash_profile && ~/bin/persist-cache'
RUN bash -c 'cd ~ && source ~/.bash_profile && cd m/pb && make base_ubuntu opt="-i inventory/packer.ini -e ansible_connection=local"'
