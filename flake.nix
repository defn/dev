{
  inputs = {
    dev.url = github:defn/pkg?dir=dev&ref=v0.0.63;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.63;
    argocd.url = github:defn/pkg?dir=argocd&ref=v0.0.63;
    earthly.url = github:defn/pkg?dir=earthly&ref=v0.0.63;
    helm.url = github:defn/pkg?dir=helm&ref=v0.0.63;
    kustomize.url = github:defn/pkg?dir=kustomize&ref=v0.0.63;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=v0.0.63;
    stern.url = github:defn/pkg?dir=stern&ref=v0.0.56;
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
              aws-vault
              pre-commit
              vim
            ];
          };
        };
    };
}
