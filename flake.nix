{
  inputs = {
    az.url = github:defn/dev/pkg-az-0.0.114?dir=m/pkg/az;
    oci.url = github:defn/dev/pkg-oci-0.0.47?dir=m/pkg/oci;
    nix.url = github:defn/dev/pkg-nix-0.0.46?dir=m/pkg/nix;
    secrets.url = github:defn/dev/pkg-secrets-0.0.49?dir=m/pkg/secrets;
    utils.url = github:defn/dev/pkg-utils-0.0.47?dir=m/pkg/utils;
    vpn.url = github:defn/dev/pkg-vpn-0.0.48?dir=m/pkg/vpn;
    vault.url = github:defn/dev/pkg-vault-1.13.2-2?dir=m/pkg/vault;
    acme.url = github:defn/dev/pkg-acme-3.0.5-11?dir=m/pkg/acme;
    tailscale.url = github:defn/dev/pkg-tailscale-1.42.0-1?dir=m/pkg/tailscale;
    development.url = github:defn/dev/pkg-development-0.0.55?dir=m/pkg/development;
    localdev.url = github:defn/dev/pkg-localdev-0.0.125?dir=m/pkg/localdev;
    cloud.url = github:defn/dev/pkg-cloud-0.0.91?dir=m/pkg/cloud;
    shell.url = github:defn/dev/pkg-shell-0.0.47?dir=m/pkg/shell;
  };

  outputs = inputs: inputs.az.inputs.cue.inputs.pkg.main rec {
    src = ./.;

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

    packages = ctx: rec {
      devShell = ctx: ctx.wrap.devShell {
        devInputs = [
          (defaultPackage ctx)
        ];
      };
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.az.defaultPackage.${ctx.system}
            inputs.nix.defaultPackage.${ctx.system}
            inputs.vpn.defaultPackage.${ctx.system}
            inputs.oci.defaultPackage.${ctx.system}
            inputs.secrets.defaultPackage.${ctx.system}
            inputs.utils.defaultPackage.${ctx.system}
            inputs.tailscale.defaultPackage.${ctx.system}
            inputs.development.defaultPackage.${ctx.system}
            inputs.localdev.defaultPackage.${ctx.system}
            inputs.cloud.defaultPackage.${ctx.system}
            inputs.vault.defaultPackage.${ctx.system}
            inputs.acme.defaultPackage.${ctx.system}
            inputs.shell.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs ++ ctx.commands;
    };

    scripts = { system }: {
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
        #docker pull quay.io/defn/dev:latest-devcontainer
        #nix develop github:defn/dev/pkg-nodedev-0.0.43?dir=m/pkg/nodedev --command devcontainer build --workspace-folder .
        code --folder-uri "vscode-remote://dev-container+$(pwd | perl -pe 's{\s+}{}g' | xxd -p)/home/ubuntu"
      '';

      up = ''
        eval "$(direnv hook bash)"
        _direnv_hook
        if ! test -e /var/run/utmp; then sudo touch /var/run/utmp; fi
        pass hello
        screen -S tilt -d -m bash -il -c "~/bin/withde ~ $(which tilt) up" || true
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
