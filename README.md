Setup ssh key in `home/.ssh/authorized_keys`

Run tilt `tilt up`

Copy ssh, gnupg, and password-store files to volume: `docker-compose cp home/. sshd:/mnt/home/.`

Restart ssh container

Configure ssh:

```
Host dev
    User ubuntu
    Hostname localhost
    Port 222s
    ForwardAgent yes
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    StreamLocalBindUnlink yes
    RemoteForward /home/ubuntu/.gnupg/S.gpg-agent /Users/defn/.gnupg/S.gpg-agent.extra
```

ssh to container `ssh dev`

vscode to container `code --remote ssh-remote+dev /home/ubuntu`
