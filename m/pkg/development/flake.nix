{
  inputs = {
    buildifier.url = github:defn/dev/pkg-buildifier-6.1.2-4?dir=m/pkg/buildifier;
    bazelisk.url = github:defn/dev/pkg-bazelisk-1.17.0-4?dir=m/pkg/bazelisk;
    ibazel.url = github:defn/dev/pkg-ibazel-0.23.3-2?dir=m/pkg/ibazel;
  };

  outputs = inputs: inputs.buildifier.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with ctx.pkgs; [
          gnumake
          git
          git-lfs
          graphviz
          inputs.bazelisk.defaultPackage.${ctx.system}
          inputs.buildifier.defaultPackage.${ctx.system}
          inputs.ibazel.defaultPackage.${ctx.system}
        ];
    };
  };
}
