FROM quay.io/defn/dev

RUN sudo ssh-keygen -A
RUN mkdir work
COPY --chown=ubuntu:ubuntu .password-store/ work/password-store
COPY service /service

USER root
