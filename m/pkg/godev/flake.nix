{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.21.0-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.0.2-4?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.18.2-3?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/commits/release-22.11
    latest.url = github:NixOS/nixpkgs?rev=5b0cc6cee71188c29b20fc0de4ea274e24336bc0;
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
