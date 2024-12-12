FROM ubuntu:24.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y direnv curl xz-utils sudo locales git build-essential rsync python3 pipx tini iproute2 iptables screen socat
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN if [ "$(id -u ubuntu)" != 1000 ]; then groupadd -r --gid 1000 ubuntu && useradd -m -s /bin/bash -g ubuntu --uid 1000 ubuntu; fi

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu

RUN uname -a

ENTRYPOINT ["bash", "-c"]
CMD ["python3 -m http.server 2345"]