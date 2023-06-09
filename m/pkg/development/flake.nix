{
  inputs = {
    ibazel.url = github:defn/dev/pkg-ibazel-0.22.0-8?dir=m/pkg/ibazel;
    buildifier.url = github:defn/dev/pkg-buildifier-6.1.2-3?dir=m/pkg/buildifier;
    bazelisk.url = github:defn/dev/pkg-bazelisk-1.17.0-3?dir=m/pkg/bazelisk;
  };

  outputs = inputs: inputs.ibazel.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with ctx.pkgs; [
          gnumake
          git
          git-lfs
          inputs.bazelisk.defaultPackage.${ctx.system}
          inputs.ibazel.defaultPackage.${ctx.system}
          inputs.buildifier.defaultPackage.${ctx.system}
        ];
    };
  };
}
