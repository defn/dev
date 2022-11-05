{
  description = "kuma";

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

          slug = "kuma";
          version = "1.8.1";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://download.konghq.com/mesh-alpine/kuma-${version}-ubuntu-${arch}.tar.gz";
            sha256 = "sha256-SdTP/4dTsP0tII4ECp7x0clydINttn2yuZqCklzOJZU=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 */bin/* $out/bin/
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
