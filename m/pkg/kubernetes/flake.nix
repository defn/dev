{
  inputs = {
    kubectl.url = github:defn/dev/pkg-kubectl-1.26.7-9?dir=m/pkg/kubectl;
    k3sup.url = github:defn/dev/pkg-k3sup-0.13.5-2?dir=m/pkg/k3sup;
    k9s.url = github:defn/dev/pkg-k9s-0.32.3-1?dir=m/pkg/k9s;
    helm.url = github:defn/dev/pkg-helm-3.14.2-1?dir=m/pkg/helm;
    kustomize.url = github:defn/dev/pkg-kustomize-5.3.0-5?dir=m/pkg/kustomize;
    stern.url = github:defn/dev/pkg-stern-1.28.0-2?dir=m/pkg/stern;
    argoworkflows.url = github:defn/dev/pkg-argoworkflows-3.5.5-1?dir=m/pkg/argoworkflows;
    argocd.url = github:defn/dev/pkg-argocd-2.10.2-1?dir=m/pkg/argocd;
    kn.url = github:defn/dev/pkg-kn-1.13.0-2?dir=m/pkg/kn;
    dapr.url = github:defn/dev/pkg-dapr-1.13.0-1?dir=m/pkg/dapr;
    vcluster.url = github:defn/dev/pkg-vcluster-0.19.4-1?dir=m/pkg/vcluster;
    kubevirt.url = github:defn/dev/pkg-kubevirt-1.2.0-1?dir=m/pkg/kubevirt;
    kuma.url = github:defn/dev/pkg-kuma-2.6.1-2?dir=m/pkg/kuma;
    cilium.url = github:defn/dev/pkg-cilium-0.16.0-1?dir=m/pkg/cilium;
    hubble.url = github:defn/dev/pkg-hubble-0.13.0-2?dir=m/pkg/hubble;
    tfo.url = github:defn/dev/pkg-tfo-2.2.0-5?dir=m/pkg/tfo;
    mirrord.url = github:defn/dev/pkg-mirrord-3.91.0-1?dir=m/pkg/mirrord;
    crossplane.url = github:defn/dev/pkg-crossplane-1.15.0-1?dir=m/pkg/crossplane;
    spire.url = github:defn/dev/pkg-spire-1.9.1-1?dir=m/pkg/spire;
  };

  outputs = inputs: inputs.kubectl.inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-kubernetes"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.kubectl.defaultPackage.${ctx.system}
            inputs.k3sup.defaultPackage.${ctx.system}
            inputs.k9s.defaultPackage.${ctx.system}
            inputs.helm.defaultPackage.${ctx.system}
            inputs.kustomize.defaultPackage.${ctx.system}
            inputs.stern.defaultPackage.${ctx.system}
            inputs.argoworkflows.defaultPackage.${ctx.system}
            inputs.argocd.defaultPackage.${ctx.system}
            inputs.kn.defaultPackage.${ctx.system}
            inputs.dapr.defaultPackage.${ctx.system}
            inputs.vcluster.defaultPackage.${ctx.system}
            inputs.kubevirt.defaultPackage.${ctx.system}
            inputs.kuma.defaultPackage.${ctx.system}
            inputs.cilium.defaultPackage.${ctx.system}
            inputs.hubble.defaultPackage.${ctx.system}
            inputs.tfo.defaultPackage.${ctx.system}
            inputs.mirrord.defaultPackage.${ctx.system}
            inputs.crossplane.defaultPackage.${ctx.system}
            inputs.spire.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs;
    };
  };
}
