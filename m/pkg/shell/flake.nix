{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
    zellij.url = github:defn/dev/pkg-zellij-0.38.1-1?dir=m/pkg/zellij;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        inputs.zellij.defaultPackage.${ctx.system}
        vim
        openssh
        screen
        powerline-go
        starship
        less
        groff
        direnv
        jq
        coreutils
        findutils
        gnumake
        git
        bashInteractive
      ];
    };
  };
}
