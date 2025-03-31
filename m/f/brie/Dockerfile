FROM ghcr.io/defn/dev

RUN cd m/svc && ln -nfs ../svc.d/tailscaled .

ENTRYPOINT ["bash", "-c"]

CMD ["source .bash_profile && cd m && m start && sudo tailscale up --ssh && sleep infinity"]