{
  inputs = {
    kubectl.url = github:defn/m/pkg-kubectl-1.25.8-6?dir=pkg/kubectl;
    k3d.url = github:defn/m/pkg-k3d-5.4.9-6?dir=pkg/k3d;
    k9s.url = github:defn/m/pkg-k9s-0.27.3-6?dir=pkg/k9s;
    helm.url = github:defn/m/pkg-helm-3.11.3-4?dir=pkg/helm;
    kustomize.url = github:defn/m/pkg-kustomize-5.0.1-6?dir=pkg/kustomize;
    stern.url = github:defn/m/pkg-stern-1.25.0-5?dir=pkg/stern;
    argoworkflows.url = github:defn/m/pkg-argoworkflows-3.4.7-4?dir=pkg/argoworkflows;
    argocd.url = github:defn/m/pkg-argocd-2.6.7-7?dir=pkg/argocd;
    kn.url = github:defn/m/pkg-kn-1.10.0-1?dir=pkg/kn;
    vcluster.url = github:defn/m/pkg-vcluster-0.15.0-5?dir=pkg/vcluster;
    kubevirt.url = github:defn/m/pkg-kubevirt-0.59.0-6?dir=pkg/kubevirt;
    velero.url = github:defn/m/pkg-velero-1.11.0-1?dir=pkg/velero;
  };

  outputs = inputs: inputs.kubectl.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.kubectl.defaultPackage.${ctx.system}
            inputs.k3d.defaultPackage.${ctx.system}
            inputs.k9s.defaultPackage.${ctx.system}
            inputs.helm.defaultPackage.${ctx.system}
            inputs.kustomize.defaultPackage.${ctx.system}
            inputs.stern.defaultPackage.${ctx.system}
            inputs.argoworkflows.defaultPackage.${ctx.system}
            inputs.argocd.defaultPackage.${ctx.system}
            inputs.kn.defaultPackage.${ctx.system}
            inputs.vcluster.defaultPackage.${ctx.system}
            inputs.kubevirt.defaultPackage.${ctx.system}
            inputs.velero.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs;
    };
  };
}
