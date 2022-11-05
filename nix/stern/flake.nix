{
  description = "stern";

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

          slug = "stern";
          version = "1.22.0";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/stern/stern/releases/download/v${version}/stern_${version}_linux_${arch}.tar.gz";
            sha256 = "sha256-bv8CjRBLU8ilPDr3UqUikt2yAktGnOWrBa7i8JVL3nI=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            find .
            install -m 0755 stern $out/bin/stern
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}