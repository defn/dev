{
  description = "hof";

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

          slug = "hof";
          version = "0.6.7";
          arch = "x86_64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/hofstadter-io/hof/releases/download/v${version}/hof_${version}_Linux_${arch}";
            sha256 = "sha256-dLzKcpgkwk16sItj14Ts6QbQu4heCFSLbQgOQG+tYLw=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/hof
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
