FROM ubuntu:24.04

WORKDIR /usr/src/app

RUN apt update && apt install -y python3

COPY meh meh

COPY main.py ./

EXPOSE 8080
ENTRYPOINT [ "python3" ]
CMD [ "main.py" ]
