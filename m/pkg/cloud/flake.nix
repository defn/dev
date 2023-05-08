{
  inputs = {
    terraform.url = github:defn/dev/pkg-terraform-1.4.6-2?dir=m/pkg/terraform;
    packer.url = github:defn/dev/pkg-packer-1.8.7-1?dir=m/pkg/packer;
    step.url = github:defn/dev/pkg-step-0.24.3-6?dir=m/pkg/step;
    awscli.url = github:defn/dev/pkg-awscli-2.11.18-1?dir=m/pkg/awscli;
    flyctl.url = github:defn/dev/pkg-flyctl-0.1.0-1?dir=m/pkg/flyctl;
  };

  outputs = inputs: inputs.terraform.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.terraform.defaultPackage.${ctx.system}
            inputs.packer.defaultPackage.${ctx.system}
            inputs.step.defaultPackage.${ctx.system}
            inputs.awscli.defaultPackage.${ctx.system}
            inputs.flyctl.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs;

      installPhase = ''
        mkdir -p $out/bin
        cp -a $src/bin/* $out/bin/
        chmod 755 $out/bin/tf $out/bin/tf-*
      '';
    };
  };
}
