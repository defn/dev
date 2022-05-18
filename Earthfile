VERSION --parallel-load --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-cache-command 0.6

IMPORT github.com/defn/cloud/lib:master AS lib

FROM lib+platform

warm:
    RUN --no-cache --secret hello echo ${hello}
