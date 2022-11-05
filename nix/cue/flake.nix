{
  description = "cue";

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

          slug = "cue";
          version = "0.4.3";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/cue-lang/cue/releases/download/v${version}/cue_v${version}_linux_${arch}.tar.gz";
            sha256 = "sha256-Xn7LYUtZJqz8NusSWIADkat8bm4Cb6fKy/6SAGusiVw=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 cue $out/bin/cue
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
