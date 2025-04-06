This document will allow you to create a coder server.
### 1. Configure the Coder tunnel

Begin by generating the Coder tunnel token. In the Cloudflare dashboard under Zero Trust create a `cloudflared` tunnel. Name it `*.servername.defn.run`, afterward it will provide you with a connector command containing the token.

Create a key-value pair with Chamber to configure the Coder tunnel `.env` varible.
```
chamber write server/servername/svc/coder-tunnel TUNNEL_TOKEN token1234
```

Return to the dashboard and set the public hostname as `*.servername.defn.run` with service `https` and `localhost:3000`

### 2. Configure a DNS record for Coder server.

To prevent Cloudflare from creating a negative DNS cache, where server is created and connected to the tunnel without a DNS, first create a CNAME record. In the `defn.run` domain, create a CNAME with the name `*.name` and the target `tunnelID.cfargotunnel.com`. Enable proxy status.

### 3. Configure the Coder server

With the `.env.example` coder server file, use Chamber to configure the `.env` varibles. 
```
cd m
cat ../svc.d/coder-server/.env.example
export CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS=true
chamber write server/penguin-dev/svc/coder-server CODER_OAUTH2_GITHUB_ALLOWED_ORGS defn
chamber write server/penguin-dev/svc/coder-server CODER_OAUTH2_GITHUB_ALLOWED_TEAMS=defn/coder-servername,defn/coder-admin
chamber write server/penguin-dev/svc/coder-server CODER_SERVER_NAME servername
chamber write server/penguin-dev/svc/coder-server CODER_SERVER_DOMAIN defn.run
chamber write server/penguin-dev/svc/coder-server CODER_OAUTH2_GITHUB_CLIENT_ID id1234
chamber write server/penguin-dev/svc/coder-server CODER_OAUTH2_GITHUB_CLIENT_SECRET secret1234
```

Create a github team `coder-servername` with the parent team `coder-admin`, add the appropiate members. Make sure to have both teams allowed in the configuration. 
To generate the `OAUTH` varibles create a Github OAuth App called `Coder servername`. 

### 4. Activate and start the server 

Activate s6 services. Use the `s6` Ansible playbook to activate coder server and coder tunnel. Limit to your server and configure the coder tunnel and coder server.
```
ansible-playbook -l servername -e server_name=servername -e service_name=coder-tunnel playbooks/s6.yaml 
ansible-playbook -l servername -e server_name=servername -e service_name=coder-server playbooks/s6.yaml 
```

After running s6 services, check if `coder-server` and `coder-tunnel` are up. If they are down, use `m start` to start them up. If there is no value, then use `m activate`. Then verify that the server and tunnel are avalible with `m log coder-server`, `m log coder-tunnel`.  

Next, update the coder `ssh` and `docker` templates. Login to the Coder server, and use `j push` to update the two template files. 
```
coder login coder.servername.defn.run 
cd coder/template
j push coder-defn-docker-template
j push coder-defn-ssh-template
```

Finally, verify that you can visit the Coder server on the browser and the two templates can be used. You can use `dev` and `duck` as names for the `ssh` and `docker` templates, respectively.