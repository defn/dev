{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.18?dir=dev;
    coder.url = github:defn/pkg/coder-0.13.4-1?dir=coder;
    codeserver.url = github:defn/pkg/codeserver-4.9.1-3?dir=codeserver;
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
        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = wrap.flakeInputs ++ (with pkgs; [
            bashInteractive

            go
            gotools
            go-tools
            golangci-lint
            gopls
            go-outline
            gopkgs
            delve

            nodejs-18_x
          ]);
        };

        apps = {
          coder = {
            type = "app";
            program = "${inputs.coder.defaultPackage.${system}}/bin/coder";
          };
          codeserver = {
            type = "app";
            program = "${inputs.codeserver.defaultPackage.${system}}/bin/code-server";
          };
        };
      };
    };
}
