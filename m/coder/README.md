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

`.env` requires a cloudflared tunnel token. 

In Zero Trust under Networks, create a `cloudflared` tunnel. Name it `*.servername.defn.run`. It will provide you with a connector command.

Ignore the command part and paste the token into `TUNNEL_TOKEN=`. Continue setting up the tunnel in Cloudflare.


Activate the `coder tunnel` and check that it is running.
```
m activate 
m log
```

The new tunnel provides you with a tunnel ID. In the Cloudflare dashboard, under your domain and then DNS, create a CNAME record with the name `*.name` and the target `tunnelID.cfargrotunnel.com`. Enable proxy status.

Next setup the coder server, connecting the tunnel to it and giving github Oauth priviledges:
Begin by symlinking the coderserver with the svc definition and creating the `.env` file
```
cd 
cd m/svc
ln -nfs ../svc.d/coder-server .
cd coder-server
cp .env.example .env
```

Before configuring the environment variables, create a new OAuth app. In the repo developer settings, create an app.  Name it `Coder-servername`and set the two URLs.
```
Homepage URL
https://coder.servername.defn.run

Authorization callback URL
https://coder.servername.defn.run/api/v2/users/oauth2/github/callback
```

Create a Github team to authorize access to the Coder server. At the git repo homepage, navigate to teams and then click on Github team `coder-admin`. Create a team named `coder-servername`.

Change `.env` to fit your Coder server. Ensure both the `coder-servername` and `coder-admin` teams are set in `CODER_OAUTH2_GITHUB_ALLOWED_TEAMS`.

Returning to the OAuth app, Generate a CLI secret and paste the secret and ID into `.env`.
Activate it.
```
cd
cd m/svc/coder-server
m activate
```


After, create the coder workspace ssh template:

Running `m log` in coder-tunnel will give you an link to the coder server. After verifying, set a ssh template. Login to the coder server.

Login to the coder server, then push the `docker` and `ssh` templates. Use `m log` to get a link to the coder server.
```
cd
cd m/coder/template
coder login servername.defn.run
j push coder-defn-ssh-template
j push coder-defn-docker-template
cd ../..
m log coder-server

```

Finally, create a workspace with the `ssh` template with the name `dev`, and/or with the `docker` template named `duck`. The server has been created and a workspace available!
