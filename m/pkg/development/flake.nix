{
  inputs = {
    ibazel.url = github:defn/m/pkg-ibazel-0.22.0-5?dir=pkg/ibazel;
    buildifier.url = github:defn/m/pkg-buildifier-6.1.1-1?dir=pkg/buildifier;
    latest.url = github:NixOS/nixpkgs?rev=e3b18e82da9ab82b572d70c162d4e13a058aeb7d;
  };

  outputs = inputs: inputs.ibazel.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          gnumake
          git
          git-lfs
          pre-commit
          bazel_6
          inputs.ibazel.defaultPackage.${ctx.system}
          inputs.buildifier.defaultPackage.${ctx.system}
        ];
    };
  };
}
