{
  inputs = {
    kubectl.url = github:defn/dev/pkg-kubectl-1.26.7-5?dir=m/pkg/kubectl;
    k3sup.url = github:defn/dev/pkg-k3sup-0.13.0-4?dir=m/pkg/k3sup;
    k9s.url = github:defn/dev/pkg-k9s-0.27.4-5?dir=m/pkg/k9s;
    helm.url = github:defn/dev/pkg-helm-3.12.3-2?dir=m/pkg/helm;
    kustomize.url = github:defn/dev/pkg-kustomize-5.0.3-5?dir=m/pkg/kustomize;
    stern.url = github:defn/dev/pkg-stern-1.26.0-1?dir=m/pkg/stern;
    argoworkflows.url = github:defn/dev/pkg-argoworkflows-3.4.11-1?dir=m/pkg/argoworkflows;
    argocd.url = github:defn/dev/pkg-argocd-2.8.3-1?dir=m/pkg/argocd;
    kn.url = github:defn/dev/pkg-kn-1.11.0-2?dir=m/pkg/kn;
    vcluster.url = github:defn/dev/pkg-vcluster-0.15.7-1?dir=m/pkg/vcluster;
    kubevirt.url = github:defn/dev/pkg-kubevirt-1.0.0-3?dir=m/pkg/kubevirt;
    linkerd.url = github:defn/dev/pkg-linkerd-2.14.0-2?dir=m/pkg/linkerd;
    cilium.url = github:defn/dev/pkg-cilium-0.15.7-2?dir=m/pkg/cilium;
    hubble.url = github:defn/dev/pkg-hubble-0.12.0-3?dir=m/pkg/hubble;
    tfo.url = github:defn/dev/pkg-tfo-2.0.0-1?dir=m/pkg/tfo;
  };

  outputs = inputs: inputs.kubectl.inputs.pkg.main rec {
    src = ./.;

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
            inputs.vcluster.defaultPackage.${ctx.system}
            inputs.kubevirt.defaultPackage.${ctx.system}
            inputs.linkerd.defaultPackage.${ctx.system}
            inputs.cilium.defaultPackage.${ctx.system}
            inputs.hubble.defaultPackage.${ctx.system}
            inputs.tfo.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs;
    };
  };
}
