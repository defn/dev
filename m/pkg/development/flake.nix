{
  inputs = {
    buildifier.url = github:defn/dev/pkg-buildifier-6.4.0-2?dir=m/pkg/buildifier;
    bazelisk.url = github:defn/dev/pkg-bazelisk-1.19.0-2?dir=m/pkg/bazelisk;
    ibazel.url = github:defn/dev/pkg-ibazel-0.24.0-2?dir=m/pkg/ibazel;
    oci.url = github:defn/dev/pkg-oci-0.0.52?dir=m/pkg/oci;
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
          inputs.oci.defaultPackage.${ctx.system}
        ];
    };
  };
}
