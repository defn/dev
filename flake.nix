{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "path:/home/ubuntu/dev";
    tilt-pkg.url = github:defn/pkg?dir=tilt&ref=v0.0.2;
    caddy-pkg.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    temporalite-pkg.url = github:defn/pkg?dir=temporalite&ref=v0.0.1;
    kubectl-pkg.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd-pkg.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home
    , tilt-pkg
    , caddy-pkg
    , temporalite-pkg
    , kubectl-pkg
    , argocd-pkg
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      tilt = tilt-pkg.defaultPackage.${system};
      caddy = caddy-pkg.defaultPackage.${system};
      temporalite = temporalite-pkg.defaultPackage.${system};
      kubectl = kubectl-pkg.defaultPackage.${system};
      argocd = argocd-pkg.defaultPackage.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = [
          home.defaultPackage.${system}
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
          pkgs.gnupg
          pkgs.pass
          pkgs.git-crypt
          pkgs.docker
          pkgs.docker-credential-helpers
          pkgs.vault
          tilt
          caddy
          temporalite
          kubectl
          argocd
        ];
      };
    });
}
