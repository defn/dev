FROM ghcr.io/defn/dev

RUN cd m/svc && ln -nfs ../svc.d/coder-server .
RUN (echo CODER_EXTRA_ARGS=--telemetry=false; echo CODER_HTTP_ADDRESS=0.0.0.0:3000; echo CODER_ACCESS_URL=https://brie.fly.dev) | sed 's#^#export #'  > m/svc/coder-server/.env
