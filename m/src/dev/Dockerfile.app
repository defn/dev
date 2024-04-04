#FROM 127.0.0.1:4999/ubuntu:22.04
FROM ubuntu:22.04

COPY store /nix/store
COPY gen/cli.bin /cli
