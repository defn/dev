{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
    kubectl.url = github:defn/dev/pkg-kubectl-1.26.7-5?dir=m/pkg/kubectl;
    k9s.url = github:defn/dev/pkg-k9s-0.27.4-5?dir=m/pkg/k9s;
    stern.url = github:defn/dev/pkg-stern-1.26.0-1?dir=m/pkg/stern;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.kubectl.defaultPackage.${ctx.system}
            inputs.k9s.defaultPackage.${ctx.system}
            inputs.stern.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs;
    };
  };
}
