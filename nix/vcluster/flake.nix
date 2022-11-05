{
  description = "vcluster";

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

          slug = "vcluster";
          version = "0.12.3";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/loft-sh/vcluster/releases/download/v${version}/vcluster-linux-${arch}";
            sha256 = "sha256-pDMhwEJBaqblFhBHw1wuZLfRDgF62c0xAvGIiEleqOU=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/vcluster
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
