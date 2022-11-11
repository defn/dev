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
}
