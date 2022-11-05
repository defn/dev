{
  description = "temporalite";

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

          slug = "temporalite";
          version = "0.2.0";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/temporalio/temporalite/releases/download/v${version}/temporalite_${version}_linux_${arch}.tar.gz";
            sha256 = "sha256-koGoHTov0j6FXnlrct3Nw9dhht8N76wHIrpYOBCNx9c=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 temporalite $out/bin/temporalite
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
