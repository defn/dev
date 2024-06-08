{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    latest.url = github:NixOS/nixpkgs?rev=63dacb46bf939521bdc93981b4cbb7ecb58427a0;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-shell"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with (import inputs.latest { system = ctx.system; }); [
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
        git-lfs
        netcat-gnu
        socat
        nmap
        perl
        bat
        bashInteractive
      ];
    };
  };
}
