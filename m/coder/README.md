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

`.env` requires a cloudflared tunnel token. When you create the tunnel you'll be given a command to use the token. Ignore the command part and paste the token into `TUNNEL_TOKEN=`

Activate the `coder tunnel` in `svc` and check that it is running.
```
cd ..
m activate
m log coder-tunnel
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

Before configuring the environment variables, create a new OAuth app. In the repo developer settings, create an app.  Name it `Coder-servername`and set the two URLs. You can use another OAuth app's URLs as a template.
```
Homepage URL
https://coder.servername.defn.run

Authorization callback URL
https://coder.servername.defn.run/api/v2/users/oauth2/github/callback
```

Create a Github team to authorize access to the Coder server. At the repo homepage, navigate to teams and then click on Github team `coder-admin`. Create a team named `coder-servername`.

Change `.env` to fit your Coder server. Make sure to add both the `coder-servername` and `coder-admin` teams to the allowed teams variable.

Generate a CLI secret and paste the secret and ID into `.env`, then activate it.
```
cd
cd m/svc
m activate
```


After, create the coder workspace ssh template.

Running `tail` in coder-tunnel will give you an authentication link to the coder server. After verifying, set a ssh template. Login to the coder server.
```
cd coder-tunnel
m log
j push coder.defn.ssh.template
coder login servername.defn.run

```

Finally, create a workspace with the ssh template with the name `dev`. The server has been created and a workspace available!
