{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    attic.url = github:zhaofengli/attic?rev=717cc95983cdc357bc347d70be20ced21f935843;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-attic"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [ inputs.attic.packages.${ctx.system}.attic ];
    };
  };
}
