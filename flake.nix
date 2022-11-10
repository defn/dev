{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:defn/dev?dir=dev&ref=v0.0.2";
    caddy-pkg.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl-pkg.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd-pkg.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
    earthly-pkg.url = github:defn/pkg?dir=earthly&ref=v0.0.5;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home
    , caddy-pkg
    , kubectl-pkg
    , argocd-pkg
    , earthly-pkg
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      caddy = caddy-pkg.defaultPackage.${system};
      kubectl = kubectl-pkg.defaultPackage.${system};
      argocd = argocd-pkg.defaultPackage.${system};
      earthly = earthly-pkg.defaultPackage.${system};
    in
    {
      devShell =
        pkgs.mkShell rec {
          buildInputs = with pkgs; [
            home.defaultPackage.${system}
            go
            gotools
            go-tools
            golangci-lint
            gopls
            go-outline
            gopkgs
            delve
            nodejs-18_x
            nixpkgs-fmt
            kubernetes-helm
            kube3d
            rsync
            gnupg
            pass
            git-crypt
            docker
            docker-credential-helpers
            vault
            caddy
            kubectl
            argocd
            earthly
          ];
        };

      defaultPackage =
        with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          name = "${slug}-${version}";

          slug = "defn-dev";
          version = "0.0.1";

          dontUnpack = true;

          installPhase = "mkdir -p $out";

          propagatedBuildInputs = [
          ];

          meta = with lib;
            {
              homepage = "https://defn.sh/${slug}";
              description = "dev environment home directory";
              platforms = platforms.linux;
            };
        };
    });
}
