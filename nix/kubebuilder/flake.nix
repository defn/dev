{
  description = "kubebuilder";

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

          slug = "kubebuilder";
          version = "3.7.0";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v${version}/kubebuilder_linux_${arch}";
            sha256 = "sha256-QNvPbEMsniQr4m7mqZsez/kwyWwbJPjgRsioSjO0XyE=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/kubebuilder
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}