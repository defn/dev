FROM quay.io/defn/dev

RUN sudo ssh-keygen -A
COPY service /service
RUN mkdir work
COPY .password-store/ work/password-store
COPY service /service

USER root
