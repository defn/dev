{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    dev.url = github:defn/pkg?dir=dev&ref=v0.0.14;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils

    , dev
    , caddy
    , kubectl
    , argocd
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      values = import ./values.nix { inherit pkgs; inherit system; };
    in
    rec {
      devShell =
        let
          inputsList = (nixpkgs.lib.attrsets.mapAttrsToList (name: value: value) inputs);
          hasDefaultPackage = (item: acc:
            acc ++
            (
              if item ? ${"defaultPackage"}
              then [ item.defaultPackage.${system} ]
              else [ ]
            ));
        in
        pkgs.mkShell
          rec {
            buildInputs =
              values.buildInputs
              ++ [ defaultPackage ]
              ++ nixpkgs.lib.lists.foldr hasDefaultPackage [ ] inputsList;
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
