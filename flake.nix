{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.3?dir=dev;

    caddy.url = github:defn/pkg/caddy-2.6.2?dir=caddy;
    argocd.url = github:defn/pkg/argocd-2.5.2?dir=argocd;
    earthly.url = github:defn/pkg/earthly-0.6.30-1?dir=earthly;
    helm.url = github:defn/pkg/helm-3.10.2?dir=helm;
    kustomize.url = github:defn/pkg/kustomize-4.5.7?dir=kustomize;
    kubectl.url = github:defn/pkg/kubectl-1.24.8-1?dir=kubectl;
    stern.url = github:defn/pkg/stern-1.22.0?dir=stern;
    tilt.url = github:defn/pkg/tilt-0.30.12?dir=tilt;
    k3d.url = github:defn/pkg/k3d-5.4.6?dir=k3d;
    flyctl.url = github:defn/pkg/flyctl-0.0.435?dir=flyctl;
    yaegi.url = github:defn/pkg/yaegi-0.14.3?dir=yaegi;

    c.url = github:defn/pkg/v0.0.63?dir=c;
    tf.url = github:defn/pkg/v0.0.63?dir=tf;
    f.url = github:defn/pkg/v0.0.63?dir=f;
  };

  outputs = inputs:
    inputs.dev.main rec {
      inherit inputs;

      config = rec {
        slug = "defn-dev";
        version = "0.0.1";
        homepage = "https://defn.sh/${slug}";
        description = "dev environment home directory";
      };

      handler = { pkgs, wrap, system }:
        rec {
          slug = config.slug;

          devShell = wrap.devShell;

          defaultPackage = wrap.nullBuilder {
            propagatedBuildInputs = with pkgs; wrap.flakeInputs ++ [
              pass
              gnupg
              powerline-go
              vim
              git-crypt
              rsync
              gnumake
              dnsutils
              openssh
              pre-commit
              vim
              aws-vault
              nixpkgs-fmt
              jq
              fzf

              docker
              docker-credential-helpers

              go
              gotools
              go-tools
              golangci-lint
              gopls
              go-outline
              gopkgs
              delve

              nodejs-18_x

              nomad
              terraform
              vault
            ];
          };
        };
    };
}
