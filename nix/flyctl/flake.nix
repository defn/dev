{
  description = "flyctl";

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

          slug = "flyctl";
          version = "0.0.429";
          arch2 = "x86_64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/superfly/flyctl/releases/download/v${version}/flyctl_${version}_Linux_${arch2}.tar.gz";
            sha256 = "sha256-RaYJVcy/iGidcwZEjHCQF1wqdkr1DFDJJI4XgR6kdik=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 flyctl $out/bin/flyctl
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
