{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.23-rc4?dir=dev;
    tailscale.url = github:defn/pkg/tailscale-1.36.0-0?dir=tailscale;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
      inherit inputs;

      src = builtins.path { path = ./.; name = config.slug; };

      config = rec {
        slug = builtins.readFile ./SLUG;
        version = builtins.readFile ./VERSION;
      };

      handler = { pkgs, wrap, system, builders, commands }: rec {
        devShell = wrap.devShell {
          devInputs = commands;
        };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };

      scripts = { system }: {
        "tailscale-start" = ''
          set -exfu

          sudo ${inputs.tailscale.defaultPackage.${system}}/bin/tailscaled "$@"
        '';

        "tailscale-up" = ''
          set -exfu

          sudo ${inputs.tailscale.defaultPackage.${system}}/bin/tailscale up "$@"
        '';

        "tailscale-save" = ''
          set -exfu

          sudo tar cvf - /var/lib/tailscale/tailscaled.state /var/lib/tailscale/certs | base64 -w 0 | pass insert -e -f $GIT_AUTHOR_NAME-tailscale
        '';

        "tailscale-restore" = ''
          set -exfu

          pass $GIT_AUTHOR_NAME-tailscale | base64 -d | (cd / && sudo tar xvf -)
        '';
      };
    };
}
