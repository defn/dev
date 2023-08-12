{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.26.1-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.1.1-2?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.20.0-1?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/commits/release-23.05
    latest.url = github:NixOS/nixpkgs?rev=3fe694c4156b84dac12627685c7ae592a71e2206
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
