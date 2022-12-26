{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.19?dir=dev;
    tailscale.url = github:defn/pkg/tailscale-1.34.1-2?dir=tailscale;
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

        devShell = wrap.devShell {
          devInputs = with packages; [
            tailscale-up
            tailscale-start
          ];
        };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };
    };
}
