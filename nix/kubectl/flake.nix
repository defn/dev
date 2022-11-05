{
  description = "kubectl";

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

          slug = "kubectl";
          version = "1.24.7";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://dl.k8s.io/release/v${version}/bin/linux/${arch}/kubectl";
            sha256 = "sha256-8QnvJ4LpaQzNEwVzzozgIFmtWw2nmju/FuDmCzN1Jo4=";
            executable = true;
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            find .
            install -m 0755 $src $out/bin/kubectl
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
