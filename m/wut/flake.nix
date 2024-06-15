{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "wut"; };

    packages = ctx: {
      wut = ctx.pkgs.writeShellScriptBin "wut" ''
        exec env LD_LIBRARY_PATH=$MEH_LD_LIBRARY_PATH python wut.py
      '';
    };

    defaultPackage = ctx: ctx.wrap.venvBuilder {
      propagatedBuildInputs = [
        (packages ctx).wut
      ];
    };
  };
}
