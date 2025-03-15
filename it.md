### Admin setup

In the tailscale console, disable the node's key expiry and add `ansible` and `spiral` ASL tags

ssh into `coder-amanibhavam-kowloon` and accept your container's access request. Then ssh back to the container and accept `kowloon` access request, and exit both. Confirm that you have tailscale ip.

```
ssh NAME-dev
ssh coder-amanibhavam-kowloon
exit
exit
tailscale ip
```

Finally, go to coder console and create the ssh workspace as `NAME-dev` with username `ubuntu`. Test that everything works by restarting docker and running `j up`.

```
docker restart
j up
```
