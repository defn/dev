{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.22?dir=dev;
    tailscale.url = github:defn/pkg/tailscale-1.34.2-0?dir=tailscale;
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
        packages.tailscale-start = pkgs.writeShellScriptBin "this-tailscale-start" ''
          set -exfu

          sudo ${inputs.tailscale.defaultPackage.${system}}/bin/tailscaled "$@"
        '';

        packages.tailscale-up = pkgs.writeShellScriptBin "this-tailscale-up" ''
          set -exfu

          sudo ${inputs.tailscale.defaultPackage.${system}}/bin/tailscale up "$@"
        '';

        packages.tailscale-save = pkgs.writeShellScriptBin "this-tailscale-save" ''
          set -exfu

          sudo tar cvf - /var/lib/tailscale/tailscaled.state /var/lib/tailscale/certs | base64 -w 0 | pass insert -e -f $GIT_AUTHOR_NAME-tailscale
        '';

        packages.tailscale-restore = pkgs.writeShellScriptBin "this-tailscale-restore" ''
          set -exfu

          pass $GIT_AUTHOR_NAME-tailscale | base64 -d | (cd / && sudo tar xvf -)
        '';

        devShell = wrap.devShell {
          devInputs = with packages; [
            tailscale-up
            tailscale-start
            tailscale-restore
            tailscale-save
          ];
        };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };
    };
}
