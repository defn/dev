{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.23-rc10?dir=dev;
    localdev.url = github:defn/pkg/localdev-0.0.15?dir=localdev;
    vault.url = github:defn/pkg/vault-1.12.2-4?dir=vault;
    kubernetes.url = github:defn/pkg/kubernetes-0.0.5?dir=kubernetes;
    cloud.url = github:defn/pkg/cloud-0.0.1?dir=cloud;
    az.url = github:defn/pkg/az-0.0.10?dir=az;
  };

  outputs = inputs: inputs.dev.main rec {
    inherit inputs;

    src = builtins.path { path = ./.; name = builtins.readFile ./SLUG; };

    handler = { pkgs, wrap, system, builders, commands, config }: rec {
      apps = {
        coder = {
          type = "app";
          program = "${inputs.localdev.inputs.coder.defaultPackage.${system}}/bin/coder";
        };

        codeserver = {
          type = "app";
          program = "${inputs.localdev.inputs.codeserver.defaultPackage.${system}}/bin/code-server";
        };

        sshd = {
          type = "app";
          program = "${pkgs.openssh}/bin/sshd";
        };

        ssh-keygen = {
          type = "app";
          program = "${pkgs.openssh}/bin/ssh-keygen";
        };
      };

      devShell = wrap.devShell {
        devInputs = [ defaultPackage ];
      };

      defaultPackage = wrap.nullBuilder {
        propagatedBuildInputs = with pkgs; wrap.flakeInputs ++ commands ++ [
          builders.yaegi

          packages.pass

          bashInteractive
          powerline-go
          vim
          gnupg
          pinentry
          rsync
          gnumake
          git
          xz
          unzip
          dnsutils
          nettools
          openssh
          htop
          pre-commit
          aws-vault
          jq
          yq
          gron
          fzf
          groff
          wget
          curl
          procps
          less
          s6
          screen

          easyrsa
          openvpn
          wireguard-tools
          wireguard-go

          docker
          docker-credential-helpers
          skopeo

          direnv
          nix-direnv
          nixpkgs-fmt
        ];
      };

      packages.pass = pkgs.writeShellScriptBin "pass" ''
        { ${pkgs.pass}/bin/pass "$@" 2>&1 1>&3 3>&- | grep -v 'problem with fast path key listing'; } 3>&1 1>&2 | cat
      '';
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
        if [[ ! "false" == "$(vault status | grep Sealed | awk '{print $NF}')" ]]; then mark vault; (cd w/vault; eval "$(direnv hook bash)"; _direnv_hook; this-vault-unseal); fi
        if test -f /run/secrets/kubernetes.io/serviceaccount/ca.crt; then mark kubernetes; this-kubeconfig; this-argocd-login || true; fi
        this-github-login
        this-vault-login
        this-fly-login
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
        if [[ -z "$(pass hello)" ]]; then gpg-agent --daemon --pinentry-program $(which pinentry-mac); fi
        pass hello
        screen -S tilt -d -m bash -il -c "~/bin/withde ~ $(which tilt) up" || true
        open 'http://localhost:10350/r/(all)/overview'
      '';
    };
  };
}
