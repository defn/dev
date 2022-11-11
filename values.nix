{ pkgs, system }: rec {
  buildInputs = [
    pkgs.go
    pkgs.gotools
    pkgs.go-tools
    pkgs.golangci-lint
    pkgs.gopls
    pkgs.go-outline
    pkgs.gopkgs
    pkgs.delve
    pkgs.nodejs-18_x
    pkgs.nixpkgs-fmt
    pkgs.kubernetes-helm
    pkgs.kube3d
    pkgs.rsync
    pkgs.vault
  ];

  defaultPackage =
    pkgs.stdenv.mkDerivation rec {
      name = "${slug}-${version}";

      slug = "defn-dev";
      version = "0.0.1";

      dontUnpack = true;

      installPhase = "mkdir -p $out";

      propagatedBuildInputs = with pkgs; [
      ];

      meta = with pkgs.lib; {
        homepage = "https://defn.sh/${slug}";
        description = "dev environment home directory";
        platforms = platforms.linux;
      };
    };
}
