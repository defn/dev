{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-kubernetes"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder { };
  };
}
