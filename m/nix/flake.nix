{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    helm.url = github:defn/dev/pkg-helm-3.16.4-1?dir=m/pkg/helm;
    kustomize.url = github:defn/dev/pkg-kustomize-5.5.0-1?dir=m/pkg/kustomize;
    shell.url = github:defn/dev/pkg-shell-0.0.70?dir=m/pkg/shell;
    latest.url = github:NixOS/nixpkgs?rev=87cc06983c14876bb56a6a84935d1a3968f35999;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-m"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.helm.defaultPackage.${ctx.system}
          inputs.kustomize.defaultPackage.${ctx.system}
          inputs.shell.defaultPackage.${ctx.system}
        ];
    };
  };
}
