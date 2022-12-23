{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.19?dir=dev;
    az.url = github:defn/pkg/az-0.0.4?dir=az;
    earthly.url = github:defn/pkg/earthly-0.6.30-3?dir=earthly;
    tilt.url = github:defn/pkg/tilt-0.30.13-3?dir=tilt;
    gh.url = github:defn/pkg/gh-2.20.2-3?dir=gh;
    webhook.url = github:defn/pkg/webhook-2.8.0?dir=webhook;
    k3d.url = github:defn/pkg/k3d-5.4.6-3?dir=k3d;
    kubectl.url = github:defn/pkg/kubectl-1.24.9-3?dir=kubectl;
    localdev.url = github:defn/pkg/localdev-0.0.2?dir=localdev;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
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

        packages.coder-template-k3d = pkgs.writeShellScriptBin "this-coder-template-k3d" ''
          set -exfu
          cd ~/coder/k3d-code-server
          coder template create --yes || true
          coder template push --yes
          # https://github.com/coder/coder/tree/main/site/static/icon
          coder template edit k3d-code-server --icon "/icon/k8s.png"
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
             this-coder-template-k3d
             ''${BROWSER:-open} http://localhost:5555
           ) &

          this-coder-server-for-orgs
        '';

        devShell = wrap.devShell {
          devInputs = [
            pkgs.gomod2nix
            packages.coder-delete-database
            packages.coder-server-for-orgs
            packages.coder-server-for-everyone
            packages.coder-server-wait-for-alive
            packages.coder-server-wait-for-dead
            packages.coder-server-stop
            packages.coder-server-kill
            packages.coder-initial-user
            packages.coder-template-docker
            packages.coder-template-k3d
            packages.coder-init
          ];
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
            nixpkgs-fmt
            jq
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
