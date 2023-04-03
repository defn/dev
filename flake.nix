{
  inputs = {
    pkg.url = github:defn/pkg/0.0.173;
    kubernetes.url = github:defn/pkg/kubernetes-0.0.27?dir=kubernetes;
    cloud.url = github:defn/pkg/cloud-0.0.20?dir=cloud;
    az.url = github:defn/pkg/az-0.0.52?dir=az;
    oci.url = github:defn/pkg/oci-0.0.4?dir=oci;
    nix.url = github:defn/pkg/nix-0.0.4?dir=nix;
    secrets.url = github:defn/pkg/secrets-0.0.6?dir=secrets;
    development.url = github:defn/pkg/development-0.0.5?dir=development;
    utils.url = github:defn/pkg/utils-0.0.4?dir=utils;
    vpn.url = github:defn/pkg/vpn-0.0.4?dir=vpn;
    localdev.url = github:defn/pkg/localdev-0.0.53?dir=localdev;
    tailscale.url = github:defn/pkg/tailscale-1.38.3-1?dir=tailscale;
    godev.url = github:defn/pkg/godev-0.0.21?dir=godev;
    nodedev.url = github:defn/pkg/nodedev-0.0.5?dir=nodedev;
    shell.url = github:defn/pkg/shell-0.0.4?dir=shell;
  };

  outputs = inputs: inputs.pkg.main rec {
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
            inputs.localdev.defaultPackage.${ctx.system}
            inputs.kubernetes.defaultPackage.${ctx.system}
            inputs.cloud.defaultPackage.${ctx.system}
            inputs.az.defaultPackage.${ctx.system}
            inputs.nix.defaultPackage.${ctx.system}
            inputs.vpn.defaultPackage.${ctx.system}
            inputs.oci.defaultPackage.${ctx.system}
            inputs.secrets.defaultPackage.${ctx.system}
            inputs.development.defaultPackage.${ctx.system}
            inputs.utils.defaultPackage.${ctx.system}
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
        if [[ ! "false" == "$(vault status | grep Sealed | awk '{print $NF}')" ]]; then mark vault; (cd w/vault; direnv allow; eval "$(direnv hook bash)"; _direnv_hook; this-vault-unseal); fi
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
        #nix develop github:defn/pkg/nodedev-0.0.5?dir=nodedev --command devcontainer build --workspace-folder .
        code --folder-uri "vscode-remote://dev-container+$(pwd | perl -pe 's{\s+}{}g' | xxd -p)/home/ubuntu"
      '';

      up = ''
        eval "$(direnv hook bash)"
        _direnv_hook
        if ! test -e /var/run/utmp; then sudo touch /var/run/utmp; fi
        pass hello
        screen -S tilt -d -m bash -il -c "~/bin/withde ~ $(which tilt) up" || true
      '';
    };
  };
}
