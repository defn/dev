{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    rustdev.url = github:defn/dev/pkg-rustdev-0.0.3?dir=m/rustdev/rustdev;
  };

  outputs = inputs: inputs.pkg.venvMain rec {
    src = builtins.path { path = ./.; name = "wut"; };

    packages = ctx: {
      wut = with ctx.pkgs; writeShellScriptBin "wut" ''
        exec env LD_LIBRARY_PATH="${lib.makeLibraryPath [glibc zlib gcc.cc]}" python wut.py
      '';
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.rustdev.defaultPackage.${ctx.system}
        ];
    };
  };
}
