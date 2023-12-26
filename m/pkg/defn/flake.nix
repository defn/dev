{
  inputs = {
    nix.url = github:defn/dev/pkg-nix-0.0.54?dir=m/pkg/nix;
    secrets.url = github:defn/dev/pkg-secrets-0.0.60?dir=m/pkg/secrets;
    utils.url = github:defn/dev/pkg-utils-0.0.54?dir=m/pkg/utils;
    development.url = github:defn/dev/pkg-development-0.0.81?dir=m/pkg/development;
    cloud.url = github:defn/dev/pkg-cloud-0.0.214?dir=m/pkg/cloud;
    kubernetes.url = github:defn/dev/pkg-kubernetes-0.0.204?dir=m/pkg/kubernetes;
    remotedev.url = github:defn/dev/pkg-remotedev-0.0.31?dir=m/pkg/remotedev;
    localdev.url = github:defn/dev/pkg-localdev-0.0.212?dir=m/pkg/localdev;
    godev.url = github:defn/dev/pkg-godev-0.0.125?dir=m/pkg/godev;
    jsdev.url = github:defn/dev/pkg-jsdev-0.0.62?dir=m/pkg/jsdev;
    pydev.url = github:defn/dev/pkg-pydev-0.0.125?dir=m/pkg/pydev;
    shell.url = github:defn/dev/pkg-shell-0.0.63?dir=m/pkg/shell;
  };

  outputs = inputs: inputs.nix.inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-defn"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        inputs.nix.defaultPackage.${ctx.system}
        inputs.secrets.defaultPackage.${ctx.system}
        inputs.utils.defaultPackage.${ctx.system}
        inputs.development.defaultPackage.${ctx.system}
        inputs.cloud.defaultPackage.${ctx.system}
        inputs.kubernetes.defaultPackage.${ctx.system}
        inputs.remotedev.defaultPackage.${ctx.system}
        inputs.localdev.defaultPackage.${ctx.system}
        inputs.godev.defaultPackage.${ctx.system}
        inputs.jsdev.defaultPackage.${ctx.system}
        inputs.pydev.defaultPackage.${ctx.system}
        inputs.shell.defaultPackage.${ctx.system}
      ];
    };
  };
}
