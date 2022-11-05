{
  description = "krew";

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

          slug = "krew";
          version = "0.4.3";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/kubernetes-sigs/krew/releases/download/v${version}/krew-linux_${arch}.tar.gz";
            sha256 = "sha256-XfMuqg6IiiVmQ5xMyy7zo+bolSLy8hJgMBceJYVYXk8=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            find .
            install -m 0755 krew-linux_${arch} $out/bin/kubectl-krew
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
