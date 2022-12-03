#!/usr/bin/env bash

function main {
    cd
    export HOME="${HOME:-$(pwd)}"

    echo 'defn/dev'

    echo '---'
    echo "auth| terminal=false | shell=${HOME}/etc/env.sh | param1='bash' | param2='-c' | param3='echo -n | pbcopy; pass pass-EBE020A544E04B9C67215280B8B6F42683E6CCEF | pbcopy'"

    #echo "macos | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='file://${HOME}/work'"

    #local devcontainer="$(printf ${HOME} | od -A n -t x1 | tr -d '[\n\t ]')"
    #echo "devcontainer | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://dev-container+${devcontainer}/home/ubuntu'"

    #echo "fly so   | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://ssh-remote+so/home/ubuntu'"
    #echo "fly the  | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://ssh-remote+the/home/ubuntu'"
    #echo "fly brie | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://ssh-remote+brie/home/ubuntu'"
    #echo "fly defn | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://ssh-remote+defn/home/ubuntu/work/cloud'"

    #echo "devpod | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://k8s-container+context=k3d-k3s-default+namespace=default+podname=dev-0+name=dev+/home/ubuntu'"
    #echo "restart devpod | terminal=false | shell=${HOME}/etc/env.sh | param1='bash' | param2='-c' | param3='kubectl -n default delete pod dev-0'"
    #echo "new devpod | terminal=false | shell=${HOME}/etc/env.sh | param1='bash' | param2='-c' | param3='cd ~/work/dev && make k3d attach'"
    #echo "delete devpod | terminal=false | shell=${HOME}/etc/env.sh | param1='bash' | param2='-c' | param3='k3d cluster delete'"

    echo '---'

    #for k3d in mini imac mbpro; do
    #    echo "vscode remote ${k3d} | terminal=false | shell=${HOME}/etc/env.sh | param1='code' | param2='--folder-uri' | param3='vscode-remote://k8s-container+context=k3d-${k3d}+namespace=${k3d}+podname=${k3d}+name=defn+image=remote+/home/ubuntu'"
    #done
}

main "$@"
