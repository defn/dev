{
  description = "caddy";

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

          slug = "caddy";
          version = "2.6.2";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/caddyserver/caddy/releases/download/v${version}/caddy_${version}_linux_${arch}.tar.gz";
            sha256 = "sha256-WvDuZaAiAQi3uWMisEGKvNpSbV9/7Fr66gKfGuvMpio=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 caddy $out/bin/caddy
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}