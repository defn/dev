{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.14?dir=dev;

    earthly.url = github:defn/pkg/earthly-0.6.30-1?dir=earthly;
    tilt.url = github:defn/pkg/tilt-0.30.13-1?dir=tilt;
    flyctl.url = github:defn/pkg/flyctl-0.0.441?dir=flyctl;

    c.url = github:defn/pkg/c-0.0.1-3?dir=c;
    tf.url = github:defn/pkg/tf-0.0.1-1?dir=tf;
    f.url = github:defn/pkg/f-0.0.1-1?dir=f;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
      inherit inputs;

      src = ./.;

      config = rec {
        slug = "defn-dev";
        version = builtins.readFile ./VERSION;
      };

      handler = { pkgs, wrap, system, builders }: rec {
        packages.pass = pkgs.writeShellScriptBin "pass" ''
          { ${pkgs.pass}/bin/pass "$@" 2>&1 1>&3 3>&- | grep -v 'problem with fast path key listing'; } 3>&1 1>&2 | cat
        '';

        defaultPackage = wrap.bashBuilder {
          src = ./.;

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

            go
            gotools
            go-tools
            golangci-lint
            gopls
            go-outline
            gopkgs
            delve

            nodejs-18_x
          ];
        };
      };
    };
}
