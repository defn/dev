{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
    zellij.url = github:defn/dev/pkg-zellij-0.37.2-2?dir=m/pkg/zellij;
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
        less
        groff
        bashInteractive
      ];
    };
  };
}
