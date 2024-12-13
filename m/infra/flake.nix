{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    terraform.url = github:defn/dev/pkg-terraform-1.10.1-1?dir=m/pkg/terraform;
    helm.url = github:defn/dev/pkg-helm-3.16.3-1?dir=m/pkg/helm;
    kustomize.url = github:defn/dev/pkg-kustomize-5.5.0-1?dir=m/pkg/kustomize;
    shell.url = github:defn/dev/pkg-shell-0.0.70?dir=m/pkg/shell;
    latest.url = github:NixOS/nixpkgs?rev=4b873163c34e9c4ac7ebaf5a74a1af4f483e027c;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-f"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.terraform.defaultPackage.${ctx.system}
          inputs.helm.defaultPackage.${ctx.system}
          inputs.kustomize.defaultPackage.${ctx.system}
          inputs.shell.defaultPackage.${ctx.system}
        ];
    };
  };
}
