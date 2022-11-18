{
  inputs = {
    dev.url = github:defn/pkg?dir=dev&ref=v0.0.54;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
    cue.url = github:defn/pkg?dir=cue&ref=v0.0.54;
    latest.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = inputs:
    inputs.dev.main {
      inherit inputs;

      config = rec {
        slug = "defn-dev";
        version = "0.0.1";
        homepage = "https://defn.sh/${slug}";
        description = "dev environment home directory";
      };

      handler = { pkgs, wrap, system }:
        let
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
        };
    };
}
