{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    flyctl.url = github:defn/dev/pkg-flyctl-0.3.47-1?dir=m/pkg/flyctl;
    shell.url = github:defn/dev/pkg-shell-0.0.70?dir=m/pkg/shell;
    latest.url = github:NixOS/nixpkgs?rev=4b873163c34e9c4ac7ebaf5a74a1af4f483e027c;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-f"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.flyctl.defaultPackage.${ctx.system}
          inputs.shell.defaultPackage.${ctx.system}
        ];
    };
  };
}
