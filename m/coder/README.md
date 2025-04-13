This document will allow you to create a coder server.

### Configure the Coder tunnel

Create a managed Coder tunnel and retrieve its tunnel token.

First, login to Cloudflare:

```
cloudflared login
```

Then, create a tunnel:

```
cloudflared tunnel create '*.servername.defn.run'
```

Configure the wildcard DNS for the tunnel:

```
cloudflared tunnel route dns '*.servername.defn.run' '*.servername.defn.run'
```

Remove the saved Cloudflare tunnel credentials (your file will be randomly named):

```
rm ~/.cloudflared/1fe10d8e-253f-474d-a3a6-41956b7f2fca.json
```

Then, configure the tunnel with the Cloudflare Web UI:

- look up the tunnel token
- configure public hostname: \*.servername on defn.run to HTTP, localhost:3000

Finally, record the tunnel token in the coder-tunnel service for the server.

```
chamber write server/servername/svc/coder-tunnel TUNNEL_TOKEN token1234
```

### Configure the Coder server

With the `.env.example` coder server file, use Chamber to configure the `.env` varibles.

```
cd m
cat ../svc.d/coder-server/.env.example
export CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS=true
chamber write server/servername/svc/coder-server CODER_OAUTH2_GITHUB_ALLOWED_ORGS defn
chamber write server/servername/svc/coder-server CODER_OAUTH2_GITHUB_ALLOWED_TEAMS defn/coder-servername,defn/coder-admin
chamber write server/servername/svc/coder-server CODER_SERVER_NAME servername
chamber write server/servername/svc/coder-server CODER_SERVER_DOMAIN defn.run
chamber write server/servername/svc/coder-server CODER_OAUTH2_GITHUB_CLIENT_ID id1234
chamber write server/servername/svc/coder-server CODER_OAUTH2_GITHUB_CLIENT_SECRET secret1234
```

Create a github team `coder-servername` with the parent team `coder-admin`, add the appropiate members. Make sure to have both teams allowed in the configuration.
To generate the `OAUTH` varibles create a Github OAuth App called `Coder servername`.

### Activate and start the server

Remotely configure and start the coder-tunnel and coder-server services.

First, change to the defn-org aws configuration:

```
cd m/a/defn/org
```

Then, run the coder playbook against the remote server:

```
m play coder servername
```

After running s6 services, check if `coder-server` and `coder-tunnel` are up. If they are down, use `m start` to start them up. If there is no value, then use `m activate`. Then verify that the server and tunnel are avalible with `m log coder-server`, `m log coder-tunnel`.

Then, update the coder `ssh` and `docker` templates. Login to the Coder server, and use `j push` to update the two template files.

```
coder login coder.servername.defn.run
cd m/coder/template
j push coder-defn-docker-template
j push coder-defn-ssh-template
```

Finally, verify that you can visit the Coder server at http://coder.servername.defn.run and the two templates can be used. You can use `dev` and `duck` as names for the `ssh` and `docker` templates, respectively.
