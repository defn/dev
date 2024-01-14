{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-shell"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        procps
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
        netcat-gnu
        socat
        bashInteractive
      ];
    };
  };
}
