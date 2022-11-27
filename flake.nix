{
  inputs = {
    dev.url = github:defn/pkg?dir=dev&ref=dev-0.0.1;
    caddy.url = github:defn/pkg?dir=caddy&ref=caddy-2.6.2;
    argocd.url = github:defn/pkg?dir=argocd&ref=argocd-2.5.2;
    earthly.url = github:defn/pkg?dir=earthly&ref=earthly-0.6.30-1;
    helm.url = github:defn/pkg?dir=helm&ref=helm-3.10.2;
    kustomize.url = github:defn/pkg?dir=kustomize&ref=kustomize-4.5.7;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=kubectl-1.24.8-1;
    stern.url = github:defn/pkg?dir=stern&ref=stern-1.22.0;

    k3d.url = github:defn/pkg?dir=k3d&ref=v0.0.63;
    c.url = github:defn/pkg?dir=c&ref=v0.0.63;
    tf.url = github:defn/pkg?dir=tf&ref=v0.0.63;
    f.url = github:defn/pkg?dir=f&ref=v0.0.63;
    flyctl.url = github:defn/pkg?dir=flyctl&ref=v0.0.63;
    yaegi.url = github:defn/pkg?dir=yaegi&ref=v0.0.63;
    tilt.url = github:defn/pkg?dir=tilt&ref=v0.0.63;

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
              pass
              gnupg
              powerline-go
              vim
              git-crypt
              vault
              rsync
              gnumake
              dnsutils
              openssh
              pre-commit
              vim
              aws-vault

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
              nomad
              terraform
            ];
          };
        };
    };
}
