{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.14?dir=dev;

    codeserver.url = github:defn/pkg/codeserver-4.9.1-rc.1?dir=codeserver;
    coder.url = github:defn/pkg/coder-0.13.3?dir=coder;
    tailscale.url = github:defn/pkg/tailscale-1.34.0-1?dir=tailscale;

    caddy.url = github:defn/pkg/caddy-2.6.2-2?dir=caddy;
    argocd.url = github:defn/pkg/argocd-2.5.4-2?dir=argocd;
    earthly.url = github:defn/pkg/earthly-0.6.30-1?dir=earthly;
    helm.url = github:defn/pkg/helm-3.10.2-1?dir=helm;
    kustomize.url = github:defn/pkg/kustomize-4.5.7-1?dir=kustomize;
    kubectl.url = github:defn/pkg/kubectl-1.24.9-1?dir=kubectl;
    stern.url = github:defn/pkg/stern-1.22.0-1?dir=stern;
    tilt.url = github:defn/pkg/tilt-0.30.13-1?dir=tilt;
    k3d.url = github:defn/pkg/k3d-5.4.6-1?dir=k3d;
    flyctl.url = github:defn/pkg/flyctl-0.0.437-1?dir=flyctl;
    step.url = github:defn/pkg/step-0.23.0-1?dir=step;

    bb.url = github:defn/pkg/bb-1.0.168?dir=bb;
    c.url = github:defn/pkg/c-0.0.1-3?dir=c;
    tf.url = github:defn/pkg/tf-0.0.1-1?dir=tf;
    f.url = github:defn/pkg/f-0.0.1-1?dir=f;

    terraform.url = github:defn/pkg/terraform-1.3.6-2?dir=terraform;
    vault.url = github:defn/pkg/vault-1.12.2-2?dir=vault;
    nomad.url = github:defn/pkg/nomad-1.4.3-2?dir=nomad;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
      inherit inputs;

      src = ./.;

      config = rec {
        slug = "defn-dev";
        version = builtins.readFile ./VERSION;
      };

      handler = { pkgs, wrap, system, builders }: rec {
        defaultPackage = wrap.bashBuilder {
          src = ./.;

          installPhase = ''
            mkdir --p $out
            #rsync -ia $src/. $out/.
          '';

          propagatedBuildInputs = with pkgs; wrap.flakeInputs ++ [
            builders.yaegi
            builders.bb

            bashInteractive
            pass
            gnupg
            powerline-go
            vim
            git-crypt
            rsync
            gnumake
            dnsutils
            nettools
            openssh
            pre-commit
            vim
            aws-vault
            nixpkgs-fmt
            jq
            fzf
            git
            wget
            curl
            xz
            procps
            less
            htop

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
          ];
        };
      };
    };
}
