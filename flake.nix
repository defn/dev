{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    hello.url = path:./dev;

    dev.url = github:defn/pkg?dir=dev&ref=v0.0.14;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        hello = inputs.hello.wrapper { other = inputs; custom = ./values.nix; inherit system; inherit pkgs; };
        slug = "defn-dev";
        version = "0.0.1";
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
      in
      rec {
        devShell = hello.devShell;
        defaultPackage = pkgs.stdenv.mkDerivation
          rec {
            name = "${slug}-${version}";

            dontUnpack = true;

            installPhase = ''
              mkdir -p $out/bin
              touch $out/bin/meh
              chmod 755 $out/bin/meh
            '';

            propagatedBuildInputs = [
            ];

            meta = with pkgs.lib; {
              homepage = "https://defn.sh/${slug}";
              description = "dev environment home directory";
              platforms = platforms.linux;
            };
          };
      }
    );
}
