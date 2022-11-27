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
    tilt.url = github:defn/pkg?dir=tilt&ref=tilt-0.30.12;
    k3d.url = github:defn/pkg?dir=k3d&ref=k3d-5.4.6;
    flyctl.url = github:defn/pkg?dir=flyctl&ref=flyctl-0.0.435;
    yaegi.url = github:defn/pkg?dir=yaegi&ref=yaegi-0.14.3;

    c.url = github:defn/pkg?dir=c&ref=v0.0.63;
    tf.url = github:defn/pkg?dir=tf&ref=v0.0.63;
    f.url = github:defn/pkg?dir=f&ref=v0.0.63;

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

          inputsList = (pkgs.lib.attrsets.mapAttrsToList (name: value: value) {
            dev = inputs.dev;

            caddy = inputs.caddy;
            argocd = inputs.argocd;
            earthly = inputs.earthly;
            helm = inputs.helm;
            kustomize = inputs.kustomize;
            kubectl = inputs.kubectl;
            stern = inputs.stern;
            tilt = inputs.tilt;
            k3d = inputs.k3d;
            flyctl = inputs.flyctl;
            yaegi = inputs.yaegi;

            c = inputs.c;
            tf = inputs.tf;
            f = inputs.f;

            latest = github:NixOS/nixpkgs/nixpkgs-unstable;
          });
          flakeInputs = pkgs.lib.lists.foldr hasDefaultPackage [ ] inputsList;

          hasDefaultPackage = (item: acc:
            acc ++
            (
              if item ? ${"defaultPackage"}
              then [ item.defaultPackage.${system} ]
              else [ ]
            ));
        in
        rec {
          devShell = wrap.devShell;

          defaultPackage = wrap.nullBuilder {
            propagatedBuildInputs = with latest; flakeInputs ++ [
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
