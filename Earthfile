VERSION --parallel-load --shell-out-anywhere --use-chmod --use-host-command 0.6

IMPORT github.com/defn/cloud/lib:master AS lib

FROM lib+platform

warm:
    RUN --no-cache true

secrets:
    RUN --secret hello echo ${hello}