{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.40.1-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.4.0-1?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-2.2.0-1?dir=m/pkg/goreleaser;
    yaegi.url = github:defn/dev/pkg-yaegi-0.16.1-2?dir=m/pkg/yaegi;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
    latest.url = github:NixOS/nixpkgs?rev=63d05d989e73c5a59bb1c4fd3b32e5e40136528d;
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
          go_1_23
          inputs.buf.defaultPackage.${ctx.system}
          inputs.cosign.defaultPackage.${ctx.system}
          inputs.goreleaser.defaultPackage.${ctx.system}
          inputs.yaegi.defaultPackage.${ctx.system}
        ];
    };
  };
}
