{
  inputs = {
    buf.url = github:defn/dev/pkg-buf-1.42.0-1?dir=m/pkg/buf;
    cosign.url = github:defn/dev/pkg-cosign-2.4.0-1?dir=m/pkg/cosign;
    goreleaser.url = github:defn/dev/pkg-goreleaser-2.3.2-1?dir=m/pkg/goreleaser;
    yaegi.url = github:defn/dev/pkg-yaegi-0.16.1-2?dir=m/pkg/yaegi;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go
    latest.url = github:NixOS/nixpkgs?rev=6802206bcc36c1be1ad0a3ff3a503d6d9502d4ac;
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
          go_1_23
          inputs.buf.defaultPackage.${ctx.system}
          inputs.cosign.defaultPackage.${ctx.system}
          inputs.goreleaser.defaultPackage.${ctx.system}
          inputs.yaegi.defaultPackage.${ctx.system}
        ];
    };
  };
}
