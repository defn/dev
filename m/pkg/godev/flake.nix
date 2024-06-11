{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.32.2-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.2.4-1?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-2.0.1-1?dir=m/pkg/goreleaser;
    yaegi.url = github:defn/dev/pkg-yaegi-0.16.1-1?dir=m/pkg/yaegi;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
    latest.url = github:NixOS/nixpkgs?rev=c06c5c6f919b02f176e91574a5bc41c504911037;
  };

  outputs = inputs: inputs.goreleaser.inputs.pkg.main rec {
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
          go_1_22
          inputs.buf.defaultPackage.${ctx.system}
          inputs.cosign.defaultPackage.${ctx.system}
          inputs.goreleaser.defaultPackage.${ctx.system}
          inputs.yaegi.defaultPackage.${ctx.system}
        ];
    };
  };
}
