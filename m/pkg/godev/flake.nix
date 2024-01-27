{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.29.0-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.2.2-4?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.23.0-1?dir=m/pkg/goreleaser;
    # https://github.com/NixOS/nixpkgs/tree/24.05-pre/pkgs/development/compilers/go
    # https://github.com/NixOS/nixpkgs/blob/24.05-pre/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=96d916a1799006f09a24cbd351c0dd270d80c117;
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
