{
  description = "tilt";

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

          slug = "tilt";
          version = "0.30.10";
          arch = "x86_64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/tilt-dev/tilt/releases/download/v${version}/tilt.${version}.linux.${arch}.tar.gz";
            sha256 = "sha256-ao1xGSoUPDcelOWHWn41BVNnG/KrHvm4L1G1n9tN7z8=";
            executable = true;
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 tilt $out/bin/tilt
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
