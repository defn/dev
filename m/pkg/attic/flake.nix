{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    attic.url = github:zhaofengli/attic?rev=47752427561f1c34debb16728a210d378f0ece36;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-attic"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [ inputs.attic.packages.${ctx.system}.attic ];
    };
  };
}
