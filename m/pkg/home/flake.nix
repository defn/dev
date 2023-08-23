{
  inputs = {
    az.url = github:defn/dev/pkg-az-0.0.142?dir=m/pkg/az;
  };

  outputs = inputs: inputs.az.inputs.cue.inputs.pkg.main rec {
    src = ./.;

    config = rec {
      clusters = {
        dfd = { };
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
      ++ (ctx.pkgs.lib.mapAttrsToList (name: value: (packages ctx).${name}) config.clusters);
    };

    packages = ctx: rec {
      devShell = ctx: ctx.wrap.devShell {
        devInputs = [
          (defaultPackage ctx)
        ];
      };
    };

    scripts = { system }: {
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

      github-login = ''
        mark github
        if ! gh auth status; then
          echo Y | gh auth login -p https -h github.com -w
        fi
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

      acme-issue = ''
        domain="$1"; shift
        export CF_Token="$(pass cloudflare_$(echo $domain | perl -pe 's{^.*?([^\.]+\.[^\.]+)$}{$1}'))"
        acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-384 -d "$domain"
      '';

      acme-renew = ''
        domain="$1"; shift
        acme.sh --renew --ecc -d "$domain"
      '';
    };
  };
}
