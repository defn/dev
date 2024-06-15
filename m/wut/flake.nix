{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "wut"; };

    devShell = ctx: with ctx; pkgs.mkShell {
      name = "wut-venv";
      venvDir = "./.venv";

      buildInputs = with pkgs.python3Packages; [
        python
        venvShellHook
        numpy
        (defaultPackage ctx) 
      ];

      postVenvCreation = ''
        unset SOURCE_DATE_EPOCH
        pip install -r requirements.txt
      '';

      postShellHook = ''
        export MEH_LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [pkgs.glibc pkgs.zlib pkgs.gcc.cc]}"
      '';
    };

    packages = ctx: {
      wut = ctx.pkgs.writeShellScriptBin "wut" ''
        exec env LD_LIBRARY_PATH=$MEH_LD_LIBRARY_PATH python wut.py
      '';
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [
        (packages ctx).wut
      ];
    };
  };
}
