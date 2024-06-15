{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "wut"; };

    devShell = ctx: with ctx.pkgs; mkShell {
      name = "wut-venv";
      venvDir = "./.venv";

      buildInputs = with python3Packages; [
        python
        venvShellHook
        numpy
        (defaultPackage ctx)
      ];

      postVenvCreation = ''
        unset SOURCE_DATE_EPOCH
        pip install -r requirements.txt
      '';
    };

    packages = ctx: {
      wut = with ctx.pkgs; writeShellScriptBin "wut" ''
        exec env LD_LIBRARY_PATH="${lib.makeLibraryPath [glibc zlib gcc.cc]}" python wut.py
      '';
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [
        (packages ctx).wut
      ];
    };
  };
}
