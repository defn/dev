{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.25.1-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.1.1-2?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.19.2-2?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/commits/release-23.05
    latest.url = github:NixOS/nixpkgs?rev=5c9ddb86679c400d6b7360797b8a22167c2053f8;
  };

  outputs = inputs: inputs.goreleaser.inputs.pkg.main rec {
    src = ./.;

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
          go_1_20
          inputs.buf.defaultPackage.${ctx.system}
          inputs.cosign.defaultPackage.${ctx.system}
          inputs.goreleaser.defaultPackage.${ctx.system}
        ];
    };
  };
}
