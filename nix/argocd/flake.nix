{
  description = "argocd";

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

          slug = "argocd";
          version = "2.5.1";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/argoproj/argo-cd/releases/download/v${version}/argocd-linux-${arch}";
            sha256 = "sha256-VB99zaJWPbAlQKuVQjK/wHsXCMQzAAF/S80Oj5fqrdc=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/argocd
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
