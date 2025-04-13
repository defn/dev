FROM ghcr.io/defn/dev

COPY build.yaml .
RUN ~/bin/with-env mise run local build.yaml

COPY entrypoint.sh /app/entrypoint.sh
ENTRYPOINT ["/apps/entrypoint.sh"]

