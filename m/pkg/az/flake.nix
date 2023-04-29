{
  inputs = {
    cue.url = github:defn/m/pkg-cue-0.5.0-4?dir=pkg/cue;
    hof.url = github:defn/m/pkg-hof-0.6.8-beta.12-3?dir=pkg/hof;
    gum.url = github:defn/m/pkg-gum-0.10.0-6?dir=pkg/gum;
    glow.url = github:defn/m/pkg-glow-1.5.0-6?dir=pkg/glow;
  };

  outputs = inputs: inputs.cue.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      propagatedBuildInputs = with ctx.pkgs; [
        inputs.gum.defaultPackage.${ctx.system}
        inputs.glow.defaultPackage.${ctx.system}
        inputs.cue.defaultPackage.${ctx.system}
        inputs.hof.defaultPackage.${ctx.system}
        jq
        yq
        gron
        fzf
        bashInteractive
      ];

      installPhase = ''
        mkdir -p $out/bin
        cp -a $src/bin/* $out/bin/
        chmod 755 $out/bin/*
      '';
    };
  };
}
