{
  inputs = {
    dev.url = github:defn/pkg/dev-0.0.19?dir=dev;
    k3d.url = github:defn/pkg/k3d-5.4.6-3?dir=k3d;
    kubectl.url = github:defn/pkg/kubectl-1.25.5-0?dir=kubectl;
    kustomize.url = github:defn/pkg/kustomize-4.5.7-3?dir=kustomize;
    helm.url = github:defn/pkg/helm-3.10.2-3?dir=helm;
    argocd.url = github:defn/pkg/argocd-2.5.4-4?dir=argocd;
    vault.url = github:defn/pkg/vault-1.12.2-4?dir=vault;
  };

  outputs = inputs:
    { main = inputs.dev.main; } // inputs.dev.main rec {
      inherit inputs;

      src = builtins.path { path = ./.; name = config.slug; };

      config = rec {
        slug = builtins.readFile ./SLUG;
        version = builtins.readFile ./VERSION;

        ts-domain = "tail3884f.ts.net";
        clusters = {
          global = { };
          control = { };
          smiley = { };
        };
      };

      handler = { pkgs, wrap, system, builders }: rec {
        packages = (pkgs.lib.mapAttrs
          (nme: value: pkgs.writeShellScriptBin nme ''
            set -efu

            name="$GIT_AUTHOR_NAME-${nme}"
            host=k3d-$name.${config.${"ts-domain"}}

            case "''${1:-}" in
              build)
                earthly +k3d
                ;;
              create)
                export DEFN_DEV_HOST_API="$(host $host | grep 'has address' | awk '{print $NF}')"
                this-k3d-provision ${nme} $name
                ;;
              ssh)
                ssh $host
                ;;
              stop)
                k3d cluster stop $name
                ;;
              start)
                k3d cluster start $name
                ;;
              delete)
                k3d cluster delete $name
                ;;
              "")
                k3d cluster list $name
                ;;
              cache)
                (this-k3d-list-images ${nme}; ssh root@$host /bin/ctr -n k8s.io images list  | awk '{print $1}' | grep -v sha256 | grep -v ^REF) | sort -u | this-k3d-save-images
                ;;
              use)
                kubectl config use-context k3d-${nme}
                ;;
              server)
                kubectl --context k3d-${nme} config view -o jsonpath='{.clusters[?(@.name == "k3d-'$name'")]}' --raw | jq -r '.cluster.server'
                ;;
              ca)
                kubectl --context k3d-${nme} config view -o jsonpath='{.clusters[?(@.name == "k3d-'$name'")]}' --raw | jq -r '.cluster["certificate-authority-data"] | @base64d'
                ;;
              vault-init)
                vault write sys/policy/k3d-${nme}-external-secrets policy=@policy-external-secrets.hcl
                vault auth enable -path "k3d-${nme}" kubernetes || true
                ;;
              vault-config)
                vault write "auth/k3d-${nme}/config" \
                  kubernetes_host="$(${nme} server)" \
                  kubernetes_ca_cert=@<(${nme} ca) \
                  disable_local_ca_jwt=true
                vault write "auth/k3d-${nme}/role/external-secrets" \
                  bound_service_account_names=external-secrets \
                  bound_service_account_namespaces=external-secrets \
                  policies=k3d-${nme}-external-secrets ttl=1h
                ;;
              *)
                kubectl --context k3d-${nme} "$@"
                ;;
            esac
          '')
          config.clusters) // {
          k3d-provision = pkgs.writeShellScriptBin "this-k3d-provision" ''
            set -exfu

            nme=$1; shift
            name=$1; shift

            export DOCKER_CONTEXT=host
            export DEFN_DEV_NAME=$name 
            export DEFN_DEV_HOST=k3d-$name
            export DEFN_DEV_HOST_IP="127.0.0.1"

            this-k3d-create $name

            kubectl config delete-context k3d-$nme || true
            kubectl config rename-context k3d-$name k3d-$nme
            case "$name" in
              *-global)
                kubectl config set-context k3d-$nme --cluster=k3d-$name --user=admin@k3d-$name --namespace argocd
                ;;
              *)
                kubectl config set-context k3d-$nme --cluster=k3d-$name --user=admin@k3d-$name
                ;;
            esac 
            perl -pe 's{(https://'$DEFN_DEV_HOST_API'):\d+}{$1:6443}' -i ~/.kube/config  

            $nme vault-init
            $nme vault-config
            
            if test -f ~/.dotfiles/e/k3d-$nme.yaml; then
              kubectl config use-context k3d-global
              while ! argocd --core app list 2>/dev/null; do date; sleep 5; done
              argocd cluster add --core --yes --upsert k3d-$nme
  
              kubectl --context k3d-global apply -f ~/.dotfiles/e/k3d-$nme.yaml
              while ! app wait argocd/k3d-$nme --timeout 30; do 
                app sync argocd/k3d-$nme || true
                sleep 1
              done
            fi
          '';

          k3d-create = pkgs.writeShellScriptBin "this-k3d-create" ''
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
            case "$name" in
              *-global)
                kustomize build --enable-helm ~/.dotfiles/k/argo-cd | docker run --rm -i \
                  -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
                  ubuntu bash -c 'tee /var/lib/rancher/k3s/server/manifests/defn-dev-argo-cd.yaml | wc -l'
                ;;
              *)
                docker run --rm \
                  -v $name-manifest:/var/lib/rancher/k3s/server/manifests \
                  ubuntu bash -c 'touch /var/lib/rancher/k3s/server/manifests/nothing.yaml'
                ;;
            esac 

            k3d cluster create $name \
              --config k3d.yaml \
              --registry-config k3d-registries.yaml \
              --k3s-node-label env=$name@server:0 \
              --volume $name-tailscale:/var/lib/tailscale@server:0 \
              --volume $name-irsa:/var/lib/rancher/k3s/server/tls2@server:0 \
              --volume $name-manifest:/var/lib/rancher/k3s/server/manifests2@server:0

            docker --context=host update --restart=no k3d-$name-server-0
          '';

          k3d-registry = pkgs.writeShellScriptBin "this-k3d-registry" ''
            k3d registry create registry --port 0.0.0.0:5000
          '';

          k3d-list-images = pkgs.writeShellScriptBin "this-k3d-list-images" ''
            set -efu

            name=$1; shift

            (kubectl --context k3d-$name get pods --all-namespaces -o json | gron | grep '\.image ='  | cut -d'"' -f2 | grep -v 169.254.32.1:5000/ | grep -v /defn/dev: | grep -v /workspace:latest) | sed 's#@.*##' | grep -v ^sha256 | sort -u
          '';

          k3d-save-images = pkgs.writeShellScriptBin "this-k3d-save-images" ''
            set -exfu

            runmany 4 'skopeo copy docker://$1 docker://169.254.32.1:5000/''${1#*/} --multi-arch all --dest-tls-verify=false --insecure-policy'
          '';
        };

        devShell = wrap.devShell {
          devInputs = (with packages; [
            k3d-provision
            k3d-create
            k3d-registry
            k3d-list-images
            k3d-save-images
            pkgs.skopeo
            pkgs.gron
          ]) ++ (pkgs.lib.mapAttrsToList (name: value: packages.${name}) config.clusters);
        };

        defaultPackage = wrap.nullBuilder {
          propagatedBuildInputs = with pkgs; wrap.flakeInputs;
        };
      };
    };
}
