{
  inputs = {
    kubectl.url = github:devn/dev/pkg-kubectl-1.25.8-6?dir=m/pkg/kubectl;
    k3d.url = github:devn/dev/pkg-k3d-5.4.9-6?dir=m/pkg/k3d;
    k9s.url = github:devn/dev/pkg-k9s-0.27.3-6?dir=m/pkg/k9s;
    helm.url = github:devn/dev/pkg-helm-3.11.3-4?dir=m/pkg/helm;
    kustomize.url = github:devn/dev/pkg-kustomize-5.0.1-6?dir=m/pkg/kustomize;
    stern.url = github:devn/dev/pkg-stern-1.25.0-5?dir=m/pkg/stern;
    argoworkflows.url = github:devn/dev/pkg-argoworkflows-3.4.7-4?dir=m/pkg/argoworkflows;
    argocd.url = github:devn/dev/pkg-argocd-2.6.7-7?dir=m/pkg/argocd;
    kn.url = github:devn/dev/pkg-kn-1.10.0-1?dir=m/pkg/kn;
    vcluster.url = github:devn/dev/pkg-vcluster-0.15.0-5?dir=m/pkg/vcluster;
    kubevirt.url = github:devn/dev/pkg-kubevirt-0.59.0-6?dir=m/pkg/kubevirt;
    velero.url = github:devn/dev/pkg-velero-1.11.0-1?dir=m/pkg/velero;
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
