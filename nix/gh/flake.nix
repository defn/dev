{
  description = "gh";

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

          slug = "gh";
          version = "2.19.0";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/cli/cli/releases/download/v${version}/gh_${version}_linux_${arch}.tar.gz";
            sha256 = "sha256-sdBi8cDURGXk+fElIek+mztlDTh26xV6z4dTR7lx9Ng=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            find .
            install -m 0755 */bin/gh $out/bin/gh
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
