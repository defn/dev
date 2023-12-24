{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.28.1-4?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.2.2-4?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.22.1-4?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/commits/main
    latest.url = github:NixOS/nixpkgs?rev=005617587ee2b7c003388b4539b9120ebcc90e44;
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
          go_1_21
          inputs.buf.defaultPackage.${ctx.system}
          inputs.cosign.defaultPackage.${ctx.system}
          inputs.goreleaser.defaultPackage.${ctx.system}
        ];
    };
  };
}
