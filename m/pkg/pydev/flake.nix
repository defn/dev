{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/interpreters/python
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=b857d97eec324bd792d84eea9e0fb61149795d91;
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
          (python3.withPackages (ps: with ps; [ pip pipx ]))
          (packages ctx).wut
        ];
    };
  };
}
