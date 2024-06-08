{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/interpreters/python
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=a47743431bb52c25eecbeda1bb2350902478befe;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-pydev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          (python3.withPackages (ps: with ps; [ pip pipx ]))
        ];
    };
  };
}
