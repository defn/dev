{
  inputs = {
    az.url = github:defn/dev/pkg-az-0.0.133?dir=m/pkg/az;
  };

  outputs = inputs: inputs.az.inputs.cue.inputs.pkg.main rec {
    src = ./.;

    config = rec {
      clusters = {
        global = { };
      };
    };

    apps = ctx: {
      tailscale = {
        type = "app";
        program = "${inputs.tailscale.defaultPackage.${ctx.system}}/bin/tailscale";
      };

      tailscaled = {
        type = "app";
        program = "${inputs.tailscale.defaultPackage.${ctx.system}}/bin/tailscaled";
      };
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        ctx.pkgs.irssi

        inputs.az.defaultPackage.${ctx.system}
      ]
      ++ ctx.commands
      ++ (ctx.pkgs.lib.mapAttrsToList (name: value: (packages ctx).${name}) config.clusters)
      ++ (with (packages ctx); [ bazel dev ]);
    };

    packages = ctx: rec {
      devShell = ctx: ctx.wrap.devShell {
        devInputs = [
          (defaultPackage ctx)
        ];
      };

      bazel = ctx.pkgs.writeShellScriptBin "bazel" ''
        exec bazelisk "$@"
      '';

      dev = ctx.pkgs.writeShellScriptBin "dev" ''
        eval "$(direnv hook bash)"
        source ${ctx.pkgs.nix-direnv}/share/nix-direnv/direnvrc
        direnv allow
        _direnv_hook
        exec bash
      '';
    } // (ctx.pkgs.lib.mapAttrs
      (nme: value: ctx.pkgs.writeShellScriptBin nme ''
        set -efu

        cd "./$(git rev-parse --show-cdup)m"

        name="$GIT_AUTHOR_NAME-${nme}"
        host=k3d-$name-server-0.$(tailscale cert 2>&1 | grep domain..use | cut -d'"' -f2 | cut -d. -f2-)

        export VAULT_ADDR=http://host.docker.internal:8200

        case "''${1:-}" in
          create)
            export DEFN_DEV_HOST_API="$(host $host | grep 'has address' | awk '{print $NF}')"
            this-k3d-provision ${nme} $name
            ${nme} get -A svc | grep -v '<none>'

            browser https://argocd.defn.run
            ${nme} password
            ;;
          vc0)
            set -x
            vcluster connect --context k3d-${nme} --kube-config-context-name=vcluster-${nme}-$1 vcluster

            kubectl config use-context vcluster-${nme}-$1
            server="$(kubectl --context vcluster-${nme}-$1 config view -o jsonpath='{.clusters[?(@.name == "vcluster-'${nme}-$1'")]}' --raw | jq -r '.cluster.server')"
            ca="$(kubectl --context vcluster-${nme}-$1 config view -o jsonpath='{.clusters[?(@.name == "vcluster-'${nme}-$1'")]}' --raw | jq -r '.cluster["certificate-authority-data"] | @base64d')"
            vault write sys/policy/vcluster-${nme}-$1-external-secrets policy=@k3d-external-secrets-vault.hcl
            vault auth enable -path "vcluster-${nme}-$1" kubernetes || true
            vault write "auth/vcluster-${nme}-$1/config" \
              kubernetes_host="$server" \
              kubernetes_ca_cert=@<(echo "$ca") \
              disable_local_ca_jwt=true
            vault write "auth/vcluster-${nme}-$1/role/external-secrets" \
              bound_service_account_names=external-secrets \
              bound_service_account_namespaces=external-secrets \
              policies=vcluster-${nme}-$1-external-secrets ttl=1h

            kubectl config use-context k3d-${nme}
            kubectl config set-context --current --namespace=argocd
            argocd cluster add --core --yes --upsert vcluster-${nme}-$1
            kubectl apply -f e/vcluster-${nme}-$1.yaml
            ;;
          root)
            docker exec -ti -u root -w /home/ubuntu k3d-$name-server-0 bash
            ;;
          shell)
            docker exec -ti -u ubuntu -w /home/ubuntu k3d-$name-server-0 bash
            ;;
          ssh)
            ssh $host
            ;;
          stop)
            k3d cluster stop $name
            ;;
          start)
            k3d cluster start $name
            ;;
          "")
            k3d cluster list $name
            ;;
          cache)
            (this-k3d-list-images ${nme}; ssh root@$host /bin/ctr -n k8s.io images list  | awk '{print $1}' | grep -v sha256 | grep -v ^REF) | sort -u | this-k3d-save-images
            ;;
          use)
            kubectl config use-context k3d-${nme}
            ;;
          password)
            argocd --context k3d-${nme} admin initial-password | head -1
            ;;
          server)
            kubectl --context k3d-${nme} config view -o jsonpath='{.clusters[?(@.name == "k3d-'$name'")]}' --raw | jq -r '.cluster.server'
            ;;
          ca)
            kubectl --context k3d-${nme} config view -o jsonpath='{.clusters[?(@.name == "k3d-'$name'")]}' --raw | jq -r '.cluster["certificate-authority-data"] | @base64d'
            ;;
          vault-init)
            vault write sys/policy/k3d-${nme}-external-secrets policy=@k3d-external-secrets-vault.hcl
            vault auth enable -path "k3d-${nme}" kubernetes || true
            ;;
          vault-config)
            vault write "auth/k3d-${nme}/config" \
              kubernetes_host="$(${nme} server)" \
              kubernetes_ca_cert=@<(${nme} ca) \
              disable_local_ca_jwt=true
            vault write "auth/k3d-${nme}/role/external-secrets" \
              bound_service_account_names=external-secrets \
              bound_service_account_namespaces=external-secrets \
              policies=k3d-${nme}-external-secrets ttl=1h
            ;;
          *)
            kubectl --context k3d-${nme} "$@"
            ;;
        esac
      '')
      config.clusters);

    scripts = { system }: {
      k3d-provision = ''
        set -exfu

        nme=$1; shift
        name=$1; shift

        export DOCKER_CONTEXT=host
        export DEFN_DEV_NAME=$name
        export DEFN_DEV_HOST=k3d-$name
        export DEFN_DEV_HOST_IP="127.0.0.1"

        this-k3d-create $name

        kubectl config delete-context k3d-$nme || true
        kubectl config rename-context k3d-$name k3d-$nme
        case "$name" in
          *-global)
            kubectl config set-context k3d-$nme --cluster=k3d-$name --user=admin@k3d-$name --namespace argocd
            ;;
          *)
            kubectl config set-context k3d-$nme --cluster=k3d-$name --user=admin@k3d-$name
            ;;
        esac
        perl -pe 's{(https://'$DEFN_DEV_HOST_API'):\d+}{$1:6443}' -i ~/.kube/config

        #export VAULT_TOKEN="$(pass Initial_Root_Token)"
        #$nme vault-init
        #$nme vault-config

        if test -f e/k3d-$nme.yaml; then
          kubectl config use-context k3d-global

          mark waiting for argocd
          while ! argocd --core app list 2>/dev/null; do date; sleep 5; done

          mark upserting k3d-$nme
          while ! argocd cluster add --core --yes --upsert k3d-$nme; do date; sleep 5; done

          mark syncing
          kubectl --context k3d-global apply -f e/k3d-$nme.yaml
          sleep 10
          argocd --core app sync argocd/k3d-$nme || true
          sleep 10
          argocd --core app sync argocd/k3d-$nme || true
          argocd --core app wait argocd/k3d-$nme --timeout 5 || true
          while true; do
            argocd --core app sync argocd/k3d-$nme || true
            if argocd --core app wait argocd/k3d-$nme --timeout 60; then
              break
            fi
            argocd --core app list | grep -v 'Synced.*Healthy'
          done
        fi
      '';

      k3d-create = ''
        set -exfu

        name=$1; shift

        k3d cluster delete $name || true

        for a in tailscale irsa; do
          docker volume create $name-$a || true
          continue
          (pass $name-$a | base64 -d) | docker run --rm -i \
            -v $name-tailscale:/var/lib/tailscale \
            -v $name-irsa:/var/lib/rancher/k3s/server/tls \
            -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
            ubuntu bash -c 'cd / & tar xvf -'
        done

        docker volume create $name-manifest || true
        case "$name" in
          *-global)
            (
              set +x
              cat ~/m/k3d-tailscale-operator.yaml \
                | sed "s#client_id: .*#client_id: \"$(pass tailscale-operator-client-id-$name)\"#" \
                | sed "s#client_secret: .*#client_secret: \"$(pass tailscale-operator-client-secret-$name)\"#"
              echo ---
              cat ~/m/k/r/argo-cd/main.yaml
              cat ~/m/k/r/coredns/main.yaml
              cat ~/m/k/r/cilium/main.yaml
            ) | docker run --rm -i \
              -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
              ubuntu bash -c 'tee /var/lib/rancher/k3s/server/manifests/bootstrap.yaml | wc -l'
            ;;
          *)
            docker run --rm \
              -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
              ubuntu bash -c 'touch /var/lib/rancher/k3s/server/manifests/nothing.yaml'
            ;;
        esac

        echo $DEFN_DEV_HOST_API
        export K3D_FIX_MOUNTS=1
        k3d cluster create $name \
          --config ~/m/k3d.yaml \
          --registry-config ~/m/k3d-registries.yaml \
          --k3s-node-label env=''${name##*-}@server:0 \
          --volume $name-tailscale:/var/lib/tailscale@server:0 \
          --volume $name-irsa:/var/lib/rancher/k3s/server/tls2@server:0 \
          --volume $name-manifest:/var/lib/rancher/k3s/server/manifests2@server:0

        docker --context=host update --restart=no k3d-$name-server-0
      '';

      k3d-registry = ''
        k3d registry create registry --port 0.0.0.0:5000
      '';

      k3d-list-images = ''
        set -efu

        name=$1; shift

        (kubectl --context k3d-$name get pods --all-namespaces -o json | gron | grep '\.image ='  | cut -d'"' -f2 | grep -v 169.254.32.1:5000/ | grep -v /defn/dev: | grep -v /workspace:latest) | sed 's#@.*##' | grep -v ^sha256 | sort -u
      '';

      k3d-save-images = ''
        set -exfu

        runmany 4 'skopeo copy docker://$1 docker://169.254.32.1:5000/''${1#*/} --multi-arch all --dest-tls-verify=false --insecure-policy'
      '';

      build = ''
        touch /tmp/cache-priv-key.pem
        chmod 600 /tmp/cache-priv-key.pem
        pass nix-serve-cache-priv-key.pem > /tmp/cache-priv-key.pem
      '';

      trust-ca = ''
        sudo security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain-db etc/ca.crt
      '';

      logout = ''
        echo yes | gh auth logout --hostname github.com
        echo RELOADAGENT | gpg-connect-agent
      '';

      login = ''
        if [[ ! "false" == "$(vault status | grep Sealed | awk '{print $NF}')" ]]; then mark vault; (direnv allow; eval "$(direnv hook bash)"; _direnv_hook; this-vault-unseal); fi
        if test -f /run/secrets/kubernetes.io/serviceaccount/ca.crt; then mark kubernetes; this-kubeconfig; this-argocd-login || true; fi
        this-github-login
        this-vault-login
        echo
      '';

      vault-login = ''
        if ! kv >/dev/null; then
          mark vault
          vault login -method=github token="$(cat ~/.config/gh/hosts.yml  | yq -r '.["github.com"].oauth_token')" | egrep -v '^(token_accessor|token) '
          kv
        fi
      '';

      github-login = ''
        mark github
        if ! gh auth status; then
          echo Y | gh auth login -p https -h github.com -w
        fi
      '';

      home-repos = ''
        for a in ~ ~/.dotfiles ~/.password-store; do (echo; echo "$a"; cd "$a" && git pull) || true; done
      '';

      all-repos = ''
        this-home-repos
        git pull
      '';

      nix-gc = ''
        nix profile wipe-history
        nix-store --gc
      '';

      ec2 = ''
        pass hello
        cat etc/ec2-user-data.template \
          | sed 's#_CONTROLIP_#'$(host k3d-control.$(wait-tailscale-domain | cut -d. -f2-) | awk '{print $NF}')'#' \
          | sed 's#_TSKEY_#'$(pass k3d-control-tskey)'#' \
          | sed 's#_K3STOKEN_#'$(docker --context host exec k3d-control-server-0 cat /var/lib/rancher/k3s/server/node-token)'#' \
          | control apply -f -
      '';

      prune = ''
          docker system prune -f
        	docker images | grep '<none>' | awk '{print $3}' | runmany 'docker rmi $1'
        	earthly prune --reset
      '';

      wg-up = ''
        sudo -A mkdir -p /etc/wireguard
        pass wg_client | base64 -d | sudo -A tee /etc/wireguard/wg0.conf > /dev/null
        sudo -A wg-quick up wg0
        this-wg-dig +noall +answer txt _apps.internal
      '';

      wg-dig = ''
        dig @$(sudo -A cat /etc/wireguard/wg0.conf | grep AllowedIPs | awk '{print $3}' | cut -d/ -f1)3 "$@"
      '';

      wg-down = ''
        sudo -A wg-quick down wg0nix-bootstrap:
      '';

      ci = ''
        set -a
        BUILDKITE_BUILD_PATH="$HOME/.buildkite-agent/builds"

        BUILDKITE_AGENT_TOKEN="$(pass BUILDKITE_AGENT_TOKEN)"
        BUILDKITE_AGENT_SPAWN="4"
        BUILDKITE_AGENT_NAME="%hostname-%spawn"
        BUILDKITE_AGENT_TAGS="queue=$GIT_AUTHOR_NAME,cpu=$(nproc)"

        OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io:443"
        BUILDEVENT_APIHOST="https://api.honeycomb.io:443"

        OTEL_EXPORTER_OTLP_HEADERS="x-honeycomb-team=$(pass HONEYCOMB_API_KEY)"
        BUILDEVENT_APIKEY="$(pass HONEYCOMB_API_KEY)"

        # TODO doesn't change the service name
        OTEL_SERVICE_NAME="buildkite-agent"
        BUILDEVENT_DATASET="buildkite-agent"

        set +a

        buildkite-agent start --tracing-backend opentelemetry
      '';

      dev = ''
        docker pull quay.io/defn/dev:latest-nix
        code --folder-uri "vscode-remote://dev-container+$(pwd | perl -pe 's{\s+}{}g' | xxd -p)$(pwd | sed "s#$HOME#/home/ubuntu#")"
      '';

      up = ''
        eval "$(direnv hook bash)"
        _direnv_hook
        if ! test -e /var/run/utmp; then sudo touch /var/run/utmp; fi
        pass hello
      '';

      acme-issue = ''
        domain="$1"; shift
        export CF_Token="$(pass cloudflare_$(echo $domain | perl -pe 's{^.*?([^\.]+\.[^\.]+)$}{$1}'))"
        acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-384 -d "$domain"
      '';

      acme-renew = ''
        domain="$1"; shift
        acme.sh --renew --ecc -d "$domain"
      '';

      vault-start = ''
        set -exfu

        vault server -config vault.hcl "$@"
      '';

      vault-unseal = ''
        set -exfu

        pass Unseal_Key_1 | curl -sSL -X PUT -d @<(jq -nrR 'inputs|{key:.}|@json') $VAULT_ADDR/v1/sys/unseal
        pass Unseal_Key_3 | curl -sSL -X PUT -d @<(jq -nrR 'inputs|{key:.}|@json') $VAULT_ADDR/v1/sys/unseal
        pass Unseal_Key_5 | curl -sSL -X PUT -d @<(jq -nrR 'inputs|{key:.}|@json') $VAULT_ADDR/v1/sys/unseal
      '';

      vault-seal = ''
        set -exfu

        vault operator seal
        rm -f ~/.vault-token
        cd ~/.password-store && git add vault && git add -u vault && git stash
      '';

      vault-backup = ''
        set -exfu

        this-vault-seal
        cd ~/.password-store
        git stash apply
        git add vault
        git add -u vault
        git commit -m "backup vault"
        git push
        git status -sb
        this-vault-unseal
      '';
    };
  };
}
