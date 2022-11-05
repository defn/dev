{
  description = "k3d";

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

          slug = "k3d";
          version = "5.4.6";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/k3d-io/k3d/releases/download/v${version}/k3d-linux-${arch}";
            sha256 = "sha256-Nc0W0Ld3RHmeYmwX4OAHsJYc7x94Xu9kcBSkGrwtMpU=";
            executable = true;
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/k3d
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}