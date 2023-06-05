{
  inputs = {
    cue.url = github:defn/dev/pkg-cue-0.5.0-7?dir=m/pkg/cue;
    gum.url = github:defn/dev/pkg-gum-0.10.0-9?dir=m/pkg/gum;
    glow.url = github:defn/dev/pkg-glow-1.5.1-3?dir=m/pkg/glow;
  };

  outputs = inputs: inputs.cue.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      propagatedBuildInputs = with ctx.pkgs; [
        inputs.gum.defaultPackage.${ctx.system}
        inputs.glow.defaultPackage.${ctx.system}
        inputs.cue.defaultPackage.${ctx.system}
        jq
        yq
        gron
        fzf
        direnv
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
