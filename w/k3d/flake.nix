{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.19?dir=dev;
    k3d.url = github:defn/pkg/k3d-5.4.6-3?dir=k3d;
    kubectl.url = github:defn/pkg/kubectl-1.25.5-0?dir=kubectl;
    kustomize.url = github:defn/pkg/kustomize-4.5.7-3?dir=kustomize;
    helm.url = github:defn/pkg/helm-3.10.2-3?dir=helm;
    argocd.url = github:defn/pkg/argocd-2.5.4-4?dir=argocd;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
      inherit inputs;

      src = builtins.path { path = ./.; name = config.slug; };

      config = rec {
        slug = builtins.readFile ./SLUG;
        version = builtins.readFile ./VERSION;
      };

      handler = { pkgs, wrap, system, builders }: rec {
        packages.global = pkgs.writeShellScriptBin "global" ''
          set -exfu

          export DEFN_DEV_HOST_API=100.64.110.16

          this-k3d-provision global
        '';

        packages.k3d-provision = pkgs.writeShellScriptBin "this-k3d-provision" ''
          set -exfu

          name=$1; shift

          export DEFN_DEV_HOST_PORT=6443 DEFN_DEV_NAME=k3d-$name DOCKER_CONTEXT=host
          export DEFN_DEV_HOST=k3d-$name

          this-k3d-create $name

          kubectl config set-context k3d-$name --cluster=k3d-$name --user=admin@k3d-$name --namespace argocd
          kubectl config use-context k3d-$name
          while ! argocd --core app list 2>/dev/null; do date; sleep 5; done
          argocd cluster add --core --yes --upsert k3d-$name
          kubectl --context k3d-$name apply -f ~/.dotfiles/e/k3d-$name.yaml
        '';

        packages.k3d-create = pkgs.writeShellScriptBin "this-k3d-create" ''
          set -exfu

          name=$1; shift

          k3d cluster delete $name || true

          for a in tailscale irsa; do
            docker volume create $name-$a || true
            (pass $name-$a | base64 -d) | docker run --rm -i \
              -v $name-tailscale:/var/lib/tailscale \
              -v $name-irsa:/var/lib/rancher/k3s/server/tls \
              -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
              ubuntu bash -c 'cd / & tar xvf -'
          done

          docker volume create $name-manifest || true
          kustomize build --enable-helm ~/.dotfiles/k/argo-cd | docker run --rm -i \
            -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
            ubuntu bash -c 'tee /var/lib/rancher/k3s/server/manifests/defn-dev-argo-cd.yaml | wc -l'

          k3d cluster create $name \
            --config k3d.yaml \
            --registry-config k3d-registries.yaml \
            --k3s-node-label env=$name@server:0 \
            --volume $name-tailscale:/var/lib/tailscale@server:0 \
            --volume $name-irsa:/var/lib/rancher/k3s/server/tls2@server:0 \
            --volume $name-manifest:/var/lib/rancher/k3s/server/manifests2@server:0

          docker --context=host update --restart=no k3d-$name-server-0
        '';

        devShell = wrap.devShell {
          devInputs = with packages; [
            global
            k3d-provision
            k3d-create
          ];
        };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };
    };
}
