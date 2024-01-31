{
  inputs = {
    terraform.url = github:defn/dev/pkg-terraform-1.7.1-1?dir=m/pkg/terraform;
    terraformdocs.url = github:defn/dev/pkg-terraformdocs-0.17.0-3?dir=m/pkg/terraformdocs;
    packer.url = github:defn/dev/pkg-packer-1.10.1-1?dir=m/pkg/packer;
    step.url = github:defn/dev/pkg-step-0.25.2-1?dir=m/pkg/step;
    awscli.url = github:defn/dev/pkg-awscli-2.15.15-1?dir=m/pkg/awscli;
    chamber.url = github:defn/dev/pkg-chamber-2.13.6-4?dir=m/pkg/chamber;
  };

  outputs = inputs: inputs.terraform.inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-cloud"; };

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      propagatedBuildInputs =
        let
          flakeInputs = [
            inputs.terraform.defaultPackage.${ctx.system}
            inputs.terraformdocs.defaultPackage.${ctx.system}
            inputs.packer.defaultPackage.${ctx.system}
            inputs.step.defaultPackage.${ctx.system}
            inputs.awscli.defaultPackage.${ctx.system}
            inputs.chamber.defaultPackage.${ctx.system}
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
