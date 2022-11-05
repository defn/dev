{
  description = "earthly";

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

          slug = "earthly";
          version = "0.6.28";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/earthly/earthly/releases/download/v${version}/earthly-linux-${arch}";
            sha256 = "sha256-TbtP/tL54B9d4I2dIUY9hKOvdf6WlYpPTMYE6xRik4Y=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/earthly
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}