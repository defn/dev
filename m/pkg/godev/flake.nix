{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.27.2-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.2.0-1?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.22.0-1?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/commits/release-23.05
    # using the latest commit from main
    latest.url = github:NixOS/nixpkgs?rev=cbc976a97c3372e1eec5db021db994b85e098d12;
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
          go_1_21
          inputs.buf.defaultPackage.${ctx.system}
          inputs.cosign.defaultPackage.${ctx.system}
          inputs.goreleaser.defaultPackage.${ctx.system}
        ];
    };
  };
}
