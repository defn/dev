FROM ghcr.io/defn/dev

COPY entrypoint.sh /app/entrypoint.sh

COPY build.yaml /app/build.yaml
RUN ~/bin/with-env mise run local /app/build.yaml

ENTRYPOINT ["/app/entrypoint.sh"]

