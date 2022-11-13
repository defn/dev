{
  inputs = {
    dev.url = github:defn/pkg?dir=dev&ref=v0.0.50;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
    latest.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = inputs:
    inputs.dev.eachDefaultSystem (system:
      let
        site = import ./config.nix;
        pkgs = import inputs.dev.wrapper.nixpkgs { inherit system; };
        wrap = inputs.dev.wrapper.wrap { other = inputs; inherit system; inherit site; };
        latest = import inputs.latest { inherit system; };
      in
      rec {
        devShell = wrap.devShell;
        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with latest; [
            rsync
            go
            gotools
            go-tools
            golangci-lint
            gopls
            go-outline
            gopkgs
            delve
            nodejs-18_x
            nixpkgs-fmt
            kubernetes-helm
            kube3d
            vault
          ];
        };
      }
    );
}
