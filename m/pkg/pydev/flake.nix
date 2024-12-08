{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/interpreters/python
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=868be2c9df2ffdb40b6aee3d156f1df603555539;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-pydev"; };

    packages = ctx: {
      wut = with ctx.pkgs; writeShellScriptBin "py" ''
        exec env LD_LIBRARY_PATH="${lib.makeLibraryPath [glibc zlib gcc.cc]}" "$@"
      '';
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          (python312.withPackages (ps: with ps; [ pip pipx ]))
          (packages ctx).wut
        ];
    };
  };
}
