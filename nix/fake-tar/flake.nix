{
  description = "fake-tar";

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

          slug = "fake-tar";
          version = "0.0.1";

          src = ./fake-tar.tar.gz;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 -D fake-tar $out/bin/tar
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "no-op tar script for fetchurl";
            platforms = platforms.linux;
          };
        };
    });
}
