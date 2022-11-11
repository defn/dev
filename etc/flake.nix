{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05"; # nixpkgs-unstable
    flake-utils.url = "github:numtide/flake-utils";
    dev.url = "github:defn/pkg?dir=dev&ref=v0.0.11";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , dev
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    rec {
      devShell =
        pkgs.mkShell rec {
          buildInputs = with pkgs; [
            dev.defaultPackage.${system}
            defaultPackage
          ];
        };

      defaultPackage =
        with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          name = "${slug}-${version}";

          slug = "TODO";
          version = "0.0.1";
          arch = if system == "x86_64-linux" then "amd64" else "arm64";

          src = pkgs.fetchurl {
            url = "https://github.com/earthly/earthly/releases/download/v${version}/earthly-linux-${arch}";
            sha256 = if arch == "amd64" then "sha256-uiYZekPpUs3qe+RjeRkR06N0N+Ek7mzPIITkiJiqNOU=" else "sha256-0hN6hggSD3q0tQptAiYfiOQsnk7X9lZCq7Jej9U3Qzk=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/earthly
          '';

          propagatedBuildInputs = with pkgs; [
          ];

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
