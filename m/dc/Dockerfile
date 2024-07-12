FROM ubuntu:24.04

RUN apt update && apt install -y git curl rsync direnv make xz-utils gpg tini sudo

RUN echo 'ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu

WORKDIR /home/ubuntu
USER ubuntu

COPY install.sh /tmp/
COPY .env /tmp/

ENTRYPOINT ["/bin/tini"]

CMD ["sleep", "infinity"]
