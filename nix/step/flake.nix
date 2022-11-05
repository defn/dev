{
  description = "step";

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

          slug = "step";
          version = "0.22.0";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/smallstep/cli/releases/download/v${version}/step_linux_${version}_${arch}.tar.gz";
            sha256 = "sha256-DXmFiiA/Xpfqbd/AkKMpuV5K1ej/WbLEVUd7MncyLgI=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 */bin/step $out/bin/step
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
