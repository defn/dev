{
  description = "teller";

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

          slug = "teller";
          version = "1.5.6";
          arch = "x86_64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/tellerops/teller/releases/download/v${version}/teller_${version}_Linux_${arch}.tar.gz";
            sha256 = "sha256-L6LI4jc2P3aaoRwpbPJuWf9MLkiPTCooxzqRgHLS6JM=";
            executable = true;
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/teller
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
