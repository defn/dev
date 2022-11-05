{
  description = "argo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage =
        with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          name = "${slug}-${version}";

          slug = "argo";
          version = "3.4.3";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/argoproj/argo-workflows/releases/download/v${version}/argo-linux-amd64.gz";
            sha256 = "sha256-g0ocwJcqiBDfw5RpsXbU3q0XsLwplol02lLYm1k1esI=";
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            cat $src | gunzip > argo
            chmod 755 argo
            install -m 0755 argo $out/bin/argo
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
