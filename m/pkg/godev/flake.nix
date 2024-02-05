{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.29.0-2?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.2.3-2?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-1.24.0-1?dir=m/pkg/goreleaser;
    yaegi.url = github:defn/dev/pkg-yaegi-0.15.1-3?dir=m/pkg/yaegi;
    # https://github.com/NixOS/nixpkgs/tree/24.05-pre/pkgs/development/compilers/go
    # https://github.com/NixOS/nixpkgs/blob/24.05-pre/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=87cc06983c14876bb56a6a84935d1a3968f35999;
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
          inputs.yaegi.defaultPackage.${ctx.system}
        ];
    };
  };
}
