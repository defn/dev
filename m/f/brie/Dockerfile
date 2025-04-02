FROM ghcr.io/defn/dev

RUN sudo rm -rf /var/lib/tailscale && sudo ln -nfs /data/tailscale /var/lib/tailscale
RUN cd m/svc && ln -nfs ../svc.d/coder-server .

RUN rm -rf ~/.config/coderv2 && ln -nfs /data/coder ~/.config/coderv2
RUN cd m/svc && ln -nfs ../svc.d/coder-server .

RUN (echo CODER_EXTRA_ARGS=--telemetry=false; echo CODER_HTTP_ADDRESS=0.0.0.0:3000; echo CODER_ACCESS_URL=https://brie.fly.dev) | sed 's#^#export #'  > m/svc/coder-server/.env

ENTRYPOINT ["bash", "-c"]

CMD ["source .bash_profile && sudo install -d -m 0700 -o ubuntu -g ubuntu /data/coder /data/tailscale && cd m && m start && (sudo tailscale up --ssh || true) && exec /bin/sleep infinity"]
