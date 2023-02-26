{
  inputs = {
    pkg.url = github:defn/pkg/0.0.166;
    vault.url = github:defn/pkg/vault-1.12.3-2?dir=vault;
    kubernetes.url = github:defn/pkg/kubernetes-0.0.8?dir=kubernetes;
    cloud.url = github:defn/pkg/cloud-0.0.5?dir=cloud;
    az.url = github:defn/pkg/az-0.0.20?dir=az;
    oci.url = github:defn/pkg/oci-0.0.1?dir=oci;
    nix.url = github:defn/pkg/nix-0.0.1?dir=nix;
    secrets.url = github:defn/pkg/secrets-0.0.3?dir=secrets;
    development.url = github:defn/pkg/development-0.0.1?dir=development;
    utils.url = github:defn/pkg/utils-0.0.1?dir=utils;
    vpn.url = github:defn/pkg/vpn-0.0.1?dir=vpn;
    localdev.url = github:defn/pkg/localdev-0.0.27?dir=localdev;
    tailscale.url = github:defn/pkg/tailscale-1.36.1-1?dir=tailscale;
    godev.url = github:defn/pkg/godev-0.0.2?dir=godev;
    nodedev.url = github:defn/pkg/nodedev-0.0.1?dir=nodedev;
    shell.url = github:defn/pkg/shell-0.0.1?dir=shell;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    apps = ctx: {
      coder = {
        type = "app";
        program = "${inputs.localdev.inputs.coder.defaultPackage.${ctx.system}}/bin/coder";
      };

      codeserver = {
        type = "app";
        program = "${(packages ctx).codeserver}/bin/code-server";
      };

      sshd = {
        type = "app";
        program = "${ctx.pkgs.openssh}/bin/sshd";
      };

      ssh-keygen = {
        type = "app";
        program = "${ctx.pkgs.openssh}/bin/ssh-keygen";
      };

      tailscale = {
        type = "app";
        program = "${inputs.tailscale.defaultPackage.${ctx.system}}/bin/tailscale";
      };

      tailscaled = {
        type = "app";
        program = "${inputs.tailscale.defaultPackage.${ctx.system}}/bin/tailscaled";
      };
    };

    packages = ctx: {
      codeserver = ctx.wrap.bashBuilder rec {
        inherit src;

        propagatedBuildInputs = [
          inputs.godev.defaultPackage.${ctx.system}
          inputs.nodedev.defaultPackage.${ctx.system}
          inputs.localdev.inputs.codeserver.defaultPackage.${ctx.system}
          ctx.pkgs.which
          ctx.pkgs.coreutils
        ];

        buildInputs = propagatedBuildInputs;

        installPhase = ''
          mkdir -p $out/bin
          (
            echo '#!/usr/bin/bash'
            echo export PATH='${ctx.pkgs.lib.makeBinPath (ctx.pkgs.lib.unique (ctx.pkgs.lib.flatten (ctx.pkgs.lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) propagatedBuildInputs))))}:$PATH'
            echo exec ${inputs.localdev.inputs.codeserver.defaultPackage.${ctx.system}}/bin/code-server '"$@"'
          ) > $out/bin/code-server
          chmod 755 $out/bin/code-server
        '';
      };
    };

    devShell = ctx: ctx.wrap.devShell {
      devInputs = [
        (defaultPackage ctx)
      ];
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      buildInputs = [
        (packages ctx).codeserver
      ];
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.vault.defaultPackage.${ctx.system}
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

          p = packages ctx;
        in
        flakeInputs ++ ctx.commands;
    };

    scripts = { system }: {
      coder-delete-database = ''
        rm -rf ~/.config/coderv2/postgres
      '';

      coder-server-for-orgs-wildcard-tls = ''
        coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
          --access-url=$(pass coder_access_url) --wildcard-access-url="$(pass coder_wildcard_access_url)" \
          --http-address=localhost:5555 \
          --tls-address=localhost:5556 \
          --tls-enable --tls-redirect-http-to-https=false \
          --tls-min-version tls13 \
          --tls-cert-file "$(pass coder_cert_file)" \
          --tls-key-file "$(pass coder_cert_key)" \
          --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
          --oauth2-github-allowed-orgs=$(pass coder_github_allowed_orgs)
      '';

      coder-initial-user = ''
        coder login --first-user-email=$(pass coder_admin_email) --first-user-password=$(pass coder_admin_password) --first-user-username=$(pass coder_admin_username) \
          --first-user-trial=false http://localhost
      '';

      coder-template-docker = ''
        set -exfu
        cd ~/coder/docker-code-server
        coder template create --yes || true
        coder template push --yes --name "$(git log . | head -1 | awk '{print $2}' | cut -b1-8)"
        # https://github.com/coder/coder/tree/main/site/static/icon
        coder template edit docker-code-server --icon "https://cdn-icons-png.flaticon.com/512/919/919853.png"
      '';

      coder-template-macos = ''
        set -exfu
        cd ~/coder/macos-code-server
        coder template create --yes || true
        coder template push --yes --name "$(git log . | head -1 | awk '{print $2}' | cut -b1-8)"
        # https://github.com/coder/coder/tree/main/site/static/icon
        coder template edit macos-code-server --icon "https://upload.wikimedia.org/wikipedia/commons/c/c9/Finder_Icon_macOS_Big_Sur.png"
      '';

      coder-server-wait-for-alive = ''
        while [[ "000" == "$(curl -sS -o /dev/null -w "%{http_code}" --connect-timeout 1 -m 1 http://localhost 2>&- )" ]]; do sleep 1; done
      '';

      coder-server-wait-for-dead = ''
        while [[ "000" != "$(curl -sS -o /dev/null -w "%{http_code}" --connect-timeout 1 -m 1 http://localhost)" ]]; do sleep 1; done
      '';

      coder-server-kill = ''
        pkill -9 -f /coder
        pkill -f postgres
        this-coder-server-wait-for-dead
        pkill -f /this-coder
      '';

      coder-server-stop = ''
        pkill -f /coder
        this-coder-server-wait-for-dead
        pkill -f /this-coder
      '';

      coder-init = ''
         (
           this-coder-server-wait-for-alive
           pass coder_access_url > .config/coderv2/url
           if ! coder users show me | grep Organizations: | grep admin; then this-coder-initial-user | cat; fi
           if ! coder template list | grep docker-code-server; then this-coder-template-docker; fi
           if ! coder template list | grep macos-code-server; then this-coder-template-macos; fi
         ) &

         for="''${1:-orgs}"

        "this-coder-server-for-$for"
      '';

      build = ''
        repo="$(git remote get-url origin)"
        branch="$(git rev-parse --abbrev-ref HEAD)"

        if test -n "''${1:-}"; then
          commit="$1"; shift
        else
          commit="$(git rev-parse HEAD)"
        fi

        touch /tmp/cache-priv-key.pem
        chmod 600 /tmp/cache-priv-key.pem
        pass nix-serve-cache-priv-key.pem > /tmp/cache-priv-key.pem

        env WH_BRANCH="$branch" WH_LOG_STDOUT=1 bin/gh-webhook push "$repo" "refs/heads/$branch" "$commit"

        kill %1 2>/dev/null || true

        wait
        echo
      '';

      trust-ca = ''
        sudo security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain-db etc/ca.crt
      '';

      down = ''
        touch .local/share/code-server/idle
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
        set -x
        if test -n "''${GIT_AUTHOR_NAME:-}"; then pass GHCR_TOKEN | docker login ghcr.io -u $GIT_AUTHOR_NAME --password-stdin; echo; fi
      '';

      fly-login = ''
        mark fly;
        if ! flyctl auth whoami; then
          flyctl auth login
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
        	-docker images | grep :5000/ | grep -E 'weeks|days' | awk '{print $1 ":" $2}' | runmany 'docker rmi $1'
        	-docker system prune -f
        	-earthly prune
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

      dev = ''
        docker pull ghcr.io/defn/dev:latest-devcontainer
        code --folder-uri "vscode-remote://dev-container+$(pwd | perl -pe 's{\s+}{}g' | xxd -p)/home/ubuntu"
      '';

      up = ''
        eval "$(direnv hook bash)"
        _direnv_hook
        if [[ "$(uname -s)" == "Darwin" ]]; then make macos; fi
        if ! test -e /var/run/utmp; then sudo touch /var/run/utmp; fi
        dirmngr --daemon || true
        pass hello
        screen -S tilt -d -m bash -il -c "~/bin/withde ~ $(which tilt) up" || true
      '';
    };
  };
}
