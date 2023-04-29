{
  inputs = {
    kubectl.url = github:defn/dev/pkg-kubectl-1.25.8-7?dir=m/pkg/kubectl;
    k3d.url = github:defn/dev/pkg-k3d-5.4.9-7?dir=m/pkg/k3d;
    k9s.url = github:defn/dev/pkg-k9s-0.27.3-7?dir=m/pkg/k9s;
    helm.url = github:defn/dev/pkg-helm-3.11.3-5?dir=m/pkg/helm;
    kustomize.url = github:defn/dev/pkg-kustomize-5.0.1-7?dir=m/pkg/kustomize;
    stern.url = github:defn/dev/pkg-stern-1.25.0-6?dir=m/pkg/stern;
    argoworkflows.url = github:defn/dev/pkg-argoworkflows-3.4.7-5?dir=m/pkg/argoworkflows;
    argocd.url = github:defn/dev/pkg-argocd-2.6.7-8?dir=m/pkg/argocd;
    kn.url = github:defn/dev/pkg-kn-1.10.0-2?dir=m/pkg/kn;
    vcluster.url = github:defn/dev/pkg-vcluster-0.15.0-6?dir=m/pkg/vcluster;
    kubevirt.url = github:defn/dev/pkg-kubevirt-0.59.0-7?dir=m/pkg/kubevirt;
    velero.url = github:defn/dev/pkg-velero-1.11.0-2?dir=m/pkg/velero;
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
