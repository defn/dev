#!/usr/bin/env bash

function main {
    cd
    export HOME="${HOME:-$(pwd)}"

    echo 'defn/dev'

    echo '---'
    echo "auth | terminal=false | shell=${HOME}/bin/withde | param1='$HOME' | param2='bash' | param3='-c' | param4='echo -n | pbcopy; pass pass-EBE020A544E04B9C67215280B8B6F42683E6CCEF | pbcopy'"

    echo '---'
}

main "$@"
