{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/rust
    latest.url = github:NixOS/nixpkgs?rev=e0464e47880a69896f0fb1810f00e0de469f770a;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-rustdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          rustc
          cargo
          lld
        ];
    };
  };
}
