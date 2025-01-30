{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    latest.url = github:NixOS/nixpkgs?rev=1de313a304bcc6c4ca14f2488041665f22c0c238;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-base"; };

    packages = ctx: {
      pass = ctx.pkgs.writeShellScriptBin "pass" ''
        { ${ctx.pkgs.pass}/bin/pass "$@" 2>&1 1>&3 3>&- | grep -v 'problem with fast path key listing'; } 3>&1 1>&2 | cat
      '';
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with (import inputs.latest { system = ctx.system; }); [
        yq
        gron
        fzf
        direnv
        ffmpeg
        ttyd
        ncdu
        nload
        cookiecutter
        bat

        docker
        docker-compose
        docker-credential-helpers
        skopeo
        dive

        gnumake
        git
        git-lfs
        graphviz

        xz
        unzip
        rsync
        dnsutils
        nettools
        htop
        wget
        curl
        procps

        (packages ctx).pass
        pinentry
        aws-vault

        procps
        vim
        openssh
        screen
        powerline-go
        starship
        less
        groff
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
        pv
        fd
        ripgrep
        nixpkgs-fmt
        nix

        bashInteractive
      ];
    };
  };
}
