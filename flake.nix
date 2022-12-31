{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.21?dir=dev;
    localdev.url = github:defn/pkg/localdev-0.0.3?dir=localdev;
    caddy.url = github:defn/pkg/caddy-2.6.2-5?dir=caddy;
    az.url = github:defn/pkg/az-0.0.8?dir=az;
    earthly.url = github:defn/pkg/earthly-0.6.30-3?dir=earthly;
    tilt.url = github:defn/pkg/tilt-0.30.13-3?dir=tilt;
    gh.url = github:defn/pkg/gh-2.21.1-0?dir=gh;
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
      packages.pass = pkgs.writeShellScriptBin "pass" ''
        { ${pkgs.pass}/bin/pass "$@" 2>&1 1>&3 3>&- | grep -v 'problem with fast path key listing'; } 3>&1 1>&2 | cat
      '';

      packages.coder-delete-database = pkgs.writeShellScriptBin "this-coder-delete-database" ''
        rm -rf ~/.config/coderv2/postgres
      '';

      packages.coder-server-for-orgs = pkgs.writeShellScriptBin "this-coder-server-for-orgs" ''
        coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
          --access-url=http://localhost:5555 --http-address=localhost:5555 \
          --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
          --oauth2-github-allowed-orgs=$(pass coder_github_allowed_orgs)
      '';

      packages.coder-server-for-everyone = pkgs.writeShellScriptBin "this-coder-server-for-everyone" ''
        coder server --no-feature-warning --cache-dir ~/.cache/coder --global-config ~/.config/coderv2 \
        --access-url=http://localhost:5555 --http-address=localhost:5555 \
        --oauth2-github-allow-signups --oauth2-github-client-id=$(pass coder_github_client_id) --oauth2-github-client-secret=$(pass coder_github_client_secret) \
        --oauth2-github-allow-everyone
      '';

      packages.coder-initial-user = pkgs.writeShellScriptBin "this-coder-initial-user" ''
        coder login --first-user-email=$(pass coder_admin_email) --first-user-password=$(pass coder_admin_password) --first-user-username=$(pass coder_admin_username) \
          --first-user-trial=false http://localhost:5555
      '';

      packages.coder-template-docker = pkgs.writeShellScriptBin "this-coder-template-docker" ''
        set -exfu
        cd ~/coder/docker-code-server
        coder template create --yes || true
        coder template push --yes
        # https://github.com/coder/coder/tree/main/site/static/icon
        coder template edit docker-code-server --icon "/icon/code.svg"
      '';

      packages.coder-server-wait-for-alive = pkgs.writeShellScriptBin "this-coder-server-wait-for-alive" ''
        while [[ "000" == "$(curl -sS -o /dev/null -w "%{http_code}" --connect-timeout 1 -m 1 http://localhost:5555)" ]]; do sleep 1; done
      '';

      packages.coder-server-wait-for-dead = pkgs.writeShellScriptBin "this-coder-server-wait-for-dead" ''
        while [[ "000" != "$(curl -sS -o /dev/null -w "%{http_code}" --connect-timeout 1 -m 1 http://localhost:5555)" ]]; do sleep 1; done
      '';

      packages.coder-server-kill = pkgs.writeShellScriptBin "this-coder-server-kill" ''
        pkill -9 -f /coder
        pkill -f postgres
        this-coder-server-wait-for-dead
        pkill -f /this-coder
      '';

      packages.coder-server-stop = pkgs.writeShellScriptBin "this-coder-server-stop" ''
        pkill -f /coder
        this-coder-server-wait-for-dead
        pkill -f /this-coder
      '';

      packages.coder-init = pkgs.writeShellScriptBin "this-coder-init" ''
         (
           this-coder-server-wait-for-alive
           this-coder-initial-user | cat
           this-coder-template-docker
           ''${BROWSER:-open} http://localhost:5555
         ) &

        this-coder-server-for-orgs
      '';

      packages.build = pkgs.writeShellScriptBin "this-build" ''
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

      devShell = wrap.devShell {
        devInputs = wrap.flakeInputs ++ (with packages; [
          coder-delete-database
          coder-server-for-orgs
          coder-server-for-everyone
          coder-server-wait-for-alive
          coder-server-wait-for-dead
          coder-server-stop
          coder-server-kill
          coder-initial-user
          coder-template-docker
          coder-init
          build
        ]);
      };

      defaultPackage = wrap.nullBuilder {
        propagatedBuildInputs = with pkgs; wrap.flakeInputs ++ [
          builders.yaegi

          packages.pass

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
          procps
          less
          htop
          s6

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
