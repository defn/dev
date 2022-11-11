{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
    dev.url = github:defn/pkg?dir=dev&ref=v0.0.14;
    caddy-pkg.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl-pkg.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd-pkg.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , dev
    , caddy-pkg
    , kubectl-pkg
    , argocd-pkg
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      caddy = caddy-pkg.defaultPackage.${system};
      kubectl = kubectl-pkg.defaultPackage.${system};
      argocd = argocd-pkg.defaultPackage.${system};
      values = import ./values.nix { inherit pkgs; inherit system; };
    in
    rec {
      devShell =
        pkgs.mkShell rec {
          buildInputs = values.buildInputs ++ [
            dev.defaultPackage.${system}
            defaultPackage
            caddy
            kubectl
            argocd
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

          propagatedBuildInputs = with pkgs; [
          ];

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "dev environment home directory";
            platforms = platforms.linux;
          };
        };
    });
}
