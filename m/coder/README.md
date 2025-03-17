# Coder Server setup
This document will allow you to create a coder server.

First, setup the cloudflare tunnel:
Symlink the `coder tunnel` in `svc` with the svc definition. Then create a `.env` file based on the `.env.example`

```
cd m/svc
ln -nfs ../svc.d/coder-tunnel .
cd coder-tunnel
cp .env.example .env
```

`.env` requires a cloudflared tunnel token. When you create the tunnel you'll be given a command to use the token. Ignore the command part and paste the token into `CLOUDFLARED_TUNNEL_TOKEN=`

Activate the `coder tunnel` in `svc` and check that it is running.
```
cd ..
s6-svcanctl -a .
tail -f coder-tunnel/log/current
```

The new tunnel provides you with a tunnel ID. Create a CNAME record with the name `*.name` and the target `tunnelID.cfagrotunnel.com`.

Then, setup the coder server connecting the tunnel to it and giving github Oauth priviledges:
Begin by symlinking the coderserver with the svc definition and creating the env file
```
cd 
cd m/svc
ln -nfs ../svc.d/coder-server .
cd coder-server
cp .env.example .env
```

In `.env` do not allow multiple signups and change the coder server name.
```
export CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS=false
export CODER_OAUTH2_GITHUB_ALLOWED_ORGS=defn
export CODER_OAUTH2_GITHUB_ALLOWED_TEAMS=defn/dev
export CODER_OAUTH2_GITHUB_CLIENT_ID=
export CODER_OAUTH2_GITHUB_CLIENT_SECRET=
export CODER_SERVER_NAME=thinkpad
export CODER_SERVER_DOMAIN=defn.run
```

In the repo developer settings, create a new OAuth app. Name it Coder `servername`and set the two URLs. You can use another OAuth app's URLs as a template.

Generate a CLI secret and paste the secret and ID into `.env`, then activate it.
```
cd
cd m/svc
s6-svscanctl -a .
```


After, create the coder workspace ssh template.

Running `tail` in coder-tunnel will give you an authentication link to the coder server. After verifying, set a ssh template. Login to the coder server.
```
cd coder-tunnel
tail -f log/current
j push coder.defn.ssh.template
coder login servername.defn.run

```

Finally, create a workspace with the ssh template with the name `dev`. The server has been created and a workspace available!
