VERSION 0.6

build:
    FROM registry.fly.io/defn:dev-tower
    COPY hello.go .
    RUN ~/bin/e go build hello.go
    SAVE ARTIFACT hello

hello:
    FROM scratch
    COPY +build/hello /
    ENTRYPOINT ["/hello"]
    SAVE IMAGE hello
