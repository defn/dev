{
  inputs = {
    argo-cd.url = github:defn/dev/r-argo-cd-0.0.31?dir=m/r/argo-cd;
    argo-workflows.url = github:defn/dev/r-argo-workflows-0.0.24?dir=m/r/argo-workflows;
  };

  outputs = inputs: inputs.argo-cd.inputs.app.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      installPhase = ''
        mkdir -p $out
        cat \
            ${inputs.argo-cd.defaultPackage.${ctx.system}}/main.yaml \
            ${inputs.argo-workflows.defaultPackage.${ctx.system}}/main.yaml \
            > $out/main.yaml
      '';
    };
  };
}
