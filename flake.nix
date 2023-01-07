{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.22?dir=dev;
    localdev.url = github:defn/pkg/localdev-0.0.3?dir=localdev;
    caddy.url = github:defn/pkg/caddy-2.6.2-5?dir=caddy;
    az.url = github:defn/pkg/az-0.0.8?dir=az;
    awscli.url = github:defn/pkg/awscli-2.0.30-2?dir=awscli;
    earthly.url = github:defn/pkg/earthly-0.6.30-3?dir=earthly;
    tilt.url = github:defn/pkg/tilt-0.30.13-3?dir=tilt;
    gh.url = github:defn/pkg/gh-2.21.2-1?dir=gh;
    webhook.url = github:defn/pkg/webhook-2.8.0?dir=webhook;
    flyctl.url = github:defn/pkg/flyctl-0.0.442-0?dir=flyctl;
    vault.url = github:defn/pkg/vault-1.12.2-4?dir=vault;
  };

  outputs = inputs: { main = inputs.dev.main; } // inputs.dev.main rec {
    inherit inputs;

    src = builtins.path { path = ./.; name = config.slug; };

    config = rec {
      slug = builtins.readFile ./SLUG;
      version = builtins.readFile ./VERSION;
    };

    handler = { pkgs, wrap, system, builders }: rec {
      commands = {
        pass = pkgs.writeShellScriptBin "pass" ''
          { ${pkgs.pass}/bin/pass "$@" 2>&1 1>&3 3>&- | grep -v 'problem with fast path key listing'; } 3>&1 1>&2 | cat
        '';

        coder-delete-database = pkgs.writeShellScriptBin "this-coder-delete-database" ''
          rm -rf ~/.config/coderv2/postgres
        '';

        coder-server-for-orgs-wildcard-tls = pkgs.writeShellScriptBin "this-coder-server-for-orgs-wildcard-tls" ''
          coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
            --access-url=$(pass coder_access_url) --wildcard-access-url="$(pass coder_wildcard_access_url)" \
            --http-address=localhost:5555 \
            --tls-address=localhost:5556 \
            --tls-enable --tls-redirect-http-to-https=false \
            --tls-min-version tls13 \
            --tls-cert-file "/Users/defn/.acme.sh/*.defn.run/fullchain.cer" \
            --tls-key-file "/Users/defn/.acme.sh/*.defn.run/*.defn.run.key" \
            --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
            --oauth2-github-allowed-orgs=$(pass coder_github_allowed_orgs)
        '';

        coder-server-for-orgs-wildcard = pkgs.writeShellScriptBin "this-coder-server-for-orgs-wildcard" ''
          coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
            --access-url=$(pass coder_access_url) --wildcard-access-url="$(pass coder_wildcard_access_url)" \
            --http-address=localhost:5555 \
            --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
            --oauth2-github-allowed-orgs=$(pass coder_github_allowed_orgs)
        '';

        coder-server-for-orgs = pkgs.writeShellScriptBin "this-coder-server-for-orgs" ''
          coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
            --access-url=http://localhost \
            --http-address=localhost:5555 \
            --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
            --oauth2-github-allowed-orgs=$(pass coder_github_allowed_orgs)
        '';

        coder-server-for-everyone = pkgs.writeShellScriptBin "this-coder-server-for-everyone" ''
          coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
          --access-url=http://localhost \
          --http-address=localhost:5555 \
          --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
          --oauth2-github-allow-everyone
        '';

        coder-initial-user = pkgs.writeShellScriptBin "this-coder-initial-user" ''
          coder login --first-user-email=$(pass coder_admin_email) --first-user-password=$(pass coder_admin_password) --first-user-username=$(pass coder_admin_username) \
            --first-user-trial=false http://localhost
        '';

        coder-template-docker = pkgs.writeShellScriptBin "this-coder-template-docker" ''
          set -exfu
          cd ~/coder/docker-code-server
          coder template create --yes || true
          coder template push --yes
          # https://github.com/coder/coder/tree/main/site/static/icon
          coder template edit docker-code-server --icon "/icon/code.svg"
        '';

        coder-server-wait-for-alive = pkgs.writeShellScriptBin "this-coder-server-wait-for-alive" ''
          while [[ "000" == "$(curl -sS -o /dev/null -w "%{http_code}" --connect-timeout 1 -m 1 http://localhost)" ]]; do sleep 1; done
        '';

        coder-server-wait-for-dead = pkgs.writeShellScriptBin "this-coder-server-wait-for-dead" ''
          while [[ "000" != "$(curl -sS -o /dev/null -w "%{http_code}" --connect-timeout 1 -m 1 http://localhost)" ]]; do sleep 1; done
        '';

        coder-server-kill = pkgs.writeShellScriptBin "this-coder-server-kill" ''
          pkill -9 -f /coder
          pkill -f postgres
          this-coder-server-wait-for-dead
          pkill -f /this-coder
        '';

        coder-server-stop = pkgs.writeShellScriptBin "this-coder-server-stop" ''
          pkill -f /coder
          this-coder-server-wait-for-dead
          pkill -f /this-coder
        '';

        coder-init = pkgs.writeShellScriptBin "this-coder-init" ''
           (
             this-coder-server-wait-for-alive
             if ! coder users show me | grep Organizations: | grep admin; then this-coder-initial-user | cat; fi
             if ! coder template list | grep docker-code-server; then this-coder-template-docker; fi
             ''${BROWSER:-open} "$(pass coder_access_url)"
           ) &

           for="''${1:-orgs}"

          "this-coder-server-for-$for"
        '';

        build = pkgs.writeShellScriptBin "this-build" ''
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

        trust-ca = pkgs.writeShellScriptBin "this-trust-ca" ''
          sudo security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain-db etc/ca.crt
        '';

        down = pkgs.writeShellScriptBin "this-down" ''
          touch .local/share/code-server/idle
        '';

        logout = pkgs.writeShellScriptBin "this-logout" ''
          echo yes | gh auth logout --hostname github.com
          echo RELOADAGENT | gpg-connect-agent
        '';

        login = pkgs.writeShellScriptBin "this-login" ''
          mark vault
          if nc -z -v localhost 8200 2>/dev/null; then \
            this-vault-unseal; fi
          mark kubeconfig, argocd
          if test -f /run/secrets/kubernetes.io/serviceaccount/ca.crt; then this-kubeconfig; this-argocd-login || true; fi
          mark github
          this-github-login
        '';

        github-login = pkgs.writeShellScriptBin "this-github-login" ''
          if ! gh auth status; then echo Y | gh auth login -p https -h github.com -w; fi
          -gh extension install cli/gh-webhook
          if test -n "''${GIT_AUTHOR_NAME:-}"; then pass GHCR_TOKEN | docker login ghcr.io -u $GIT_AUTHOR_NAME --password-stdin; fi
          -vault login -method=github token="$(cat ~/.config/gh/hosts.yml  | yq -r '.["github.com"].oauth_token')"
        '';

        home-repos = pkgs.writeShellScriptBin "this-home-repos" ''
          for a in ~ ~/.dotfiles ~/.password-store; do (echo; echo "$a"; cd "$a" && git pull) || true; done
        '';

        all-repos = pkgs.writeShellScriptBin "this-all-repos" ''
          this-home-repos
          git pull
        '';
      };

      devShell = wrap.devShell {
        devInputs = wrap.flakeInputs ++ (pkgs.lib.attrsets.mapAttrsToList (name: value: value) commands);
      };

      defaultPackage = wrap.nullBuilder {
        propagatedBuildInputs = with pkgs; wrap.flakeInputs ++ [
          builders.yaegi

          commands.pass

          bashInteractive
          gnupg
          powerline-go
          vim
          rsync
          gnumake
          dnsutils
          nettools
          openssh
          pre-commit
          aws-vault
          jq
          yq
          gron
          fzf
          git
          wget
          curl
          xz
          unzip
          procps
          less
          htop
          s6
          screen
          groff

          docker
          docker-credential-helpers
          skopeo

          pinentry
          direnv
          nix-direnv
          nixpkgs-fmt
        ];
      };

      apps = {
        coder = {
          type = "app";
          program = "${inputs.localdev.inputs.coder.defaultPackage.${system}}/bin/coder";
        };

        codeserver = {
          type = "app";
          program = "${inputs.localdev.inputs.codeserver.defaultPackage.${system}}/bin/code-server";
        };
      };
    };
  };
}
