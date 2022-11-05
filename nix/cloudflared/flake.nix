{
  description = "cloudflared";

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

          slug = "cloudflared";
          version = "2022.10.3";
          arch = "amd64"; # aarch64

          src = pkgs.fetchurl {
            url = "https://github.com/cloudflare/cloudflared/releases/download/${version}/cloudflared-linux-${arch}";
            sha256 = "sha256-sVj9EkB0W5S7zBFIiO+LIDQ05CNmSFOd5MIjvAZvD+Y=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/cloudflared
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}