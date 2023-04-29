{
  inputs = {
    buf.url = github:defn/m/pkg-buf-1.17.0-6?dir=pkg/buf;
    cosign.url = github:defn/m/pkg-cosign-2.0.2-1?dir=pkg/cosign;
    goreleaser.url = github:defn/m/pkg-goreleaser-1.17.2-1?dir=pkg/goreleaser;
    latest.url = github:NixOS/nixpkgs?rev=e3b18e82da9ab82b572d70c162d4e13a058aeb7d;
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
          bashInteractive
        ];
    };
  };
}
