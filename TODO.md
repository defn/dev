vm:
    sshd: StreamLocalBindUnlink=yes
    ssh: on remote: gpgconf  --list-dirs
        Host
        Hostname
        User ubuntu
        Port 2222
        ForwardAgent true
        StreamLocalBindUnlink yes
        RemoteForward /home/ubuntu/.gnupg/S.gpg-agent /Users/defn/.gnupg/S.gpg-agent.extra
        RemoteForward /home/ubuntu/.gnupg/S.gpg-agent.extra /Users/defn/.gnupg/S.gpg-agent.extra
        StrictHostKeyChecking no
        UserKnownHostsFile=/dev/null
        ServerAliveInterval 60
        ServerAliveCountMax 5
    install: pass, git-crypt
    symlink: git-crypt to /usr/local/bin/
    symlink: .gnupg2 to .gnupg
    gpg-agent: maybe remove from remote
    vscode: code --folder-uri vscode-remote://ssh-remote+defn/home/ubuntu
