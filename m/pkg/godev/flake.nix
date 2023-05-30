{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.20.0-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.0.2-4?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.18.2-3?dir=m/pkg/goreleaser;
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
