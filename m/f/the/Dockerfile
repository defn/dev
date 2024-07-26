FROM ubuntu:24.04

WORKDIR /usr/src/app

RUN apt update && apt install -y python3

COPY index.html ./

EXPOSE 8080
ENTRYPOINT [ "bash", "-c"]
CMD [ "set -x; python3 -m http.server 8080" ]
