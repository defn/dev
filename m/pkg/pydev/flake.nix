{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/commits/main
    latest.url = github:NixOS/nixpkgs?rev=005617587ee2b7c003388b4539b9120ebcc90e44;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-pydev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          (python311.withPackages (ps: with ps; [ pipx ]))
        ];
    };
  };
}
