{
  inputs = {
    terraform.url = github:devn/dev/pkg-terraform-1.4.6-1?dir=m/pkg/terraform;
    packer.url = github:devn/dev/pkg-packer-1.8.6-7?dir=m/pkg/packer;
    step.url = github:devn/dev/pkg-step-0.24.3-5?dir=m/pkg/step;
    awscli.url = github:devn/dev/pkg-awscli-2.11.15-1?dir=m/pkg/awscli;
  };

  outputs = inputs: inputs.terraform.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.awscli.defaultPackage.${ctx.system}
            inputs.terraform.defaultPackage.${ctx.system}
            inputs.packer.defaultPackage.${ctx.system}
            inputs.step.defaultPackage.${ctx.system}
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
