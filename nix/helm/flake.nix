{
  description = "helm";

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

          slug = "helm";
          version = "3.10.1";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://get.helm.sh/helm-v${version}-linux-${arch}.tar.gz";
            sha256 = "sha256-wS0s1jjy0Gb+wSPQvX8BDzLGQ6/fKI05pGELH5yzKvM=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 */helm $out/bin/helm
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
