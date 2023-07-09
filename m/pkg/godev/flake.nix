{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.23.1-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.1.1-1?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.19.2-1?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/commits/release-22.11
    latest.url = github:NixOS/nixpkgs?rev=ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b;
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
