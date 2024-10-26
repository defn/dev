{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
    latest.url = github:NixOS/nixpkgs?rev=5942e21e4e4add4d1e3a35415534c936ac75f001;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-godev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          gcc
          gotools
          go-tools
          golangci-lint
          go-outline
          gopkgs
          delve
          gopls
          go_1_23
        ];
    };
  };
}
