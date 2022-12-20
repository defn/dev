{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.18?dir=dev;
    c.url = github:defn/pkg/c-0.0.1-6?dir=c;
    earthly.url = github:defn/pkg/earthly-0.6.30-3?dir=earthly;
    tilt.url = github:defn/pkg/tilt-0.30.13-3?dir=tilt;
    gh.url = github:defn/pkg/gh-2.20.2-3?dir=gh;
    dev-env.url = path:./coder;
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

        defaultPackage = wrap.bashBuilder {
          inherit src;

          installPhase = ''
            mkdir --p $out
            #rsync -ia $src/. $out/.
          '';

          propagatedBuildInputs = with pkgs; wrap.flakeInputs ++ [
            builders.yaegi

            packages.pass

            bashInteractive
            gnupg
            powerline-go
            vim
            git-crypt
            rsync
            gnumake
            dnsutils
            nettools
            openssh
            pre-commit
            vim
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

            docker
            docker-credential-helpers
          ];
        };
      };
    };
}
