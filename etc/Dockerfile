FROM defn/dev

RUN touch /tmp/meh1
RUN touch /tmp/meh2

RUN sudo apt update && sudo apt install -y htop

ENTRYPOINT ["bash", "-c", "set -x; uname -a; date; sleep 86400"]
