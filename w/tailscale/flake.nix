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
        devShell = wrap.devShell { };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };
    };
}
