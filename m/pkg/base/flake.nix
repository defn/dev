{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    latest.url = github:NixOS/nixpkgs?rev=1de313a304bcc6c4ca14f2488041665f22c0c238;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-base"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with (import inputs.latest { system = ctx.system; }); [
        bat
        bc
        bind
        bzip2
        coreutils
        curl
        diffutils
        direnv
        dive
        dnsutils
        file
        findutils
        fzf
        gawk
        git
        git-lfs
        gnugrep
        gnumake
        gnused
        gnutar
        groff
        gron
        gzip
        htop
        iputils
        jq
        less
        ncdu
        netcat-gnu
        nettools
        nix
        nixpkgs-fmt
        nmap
        openssh
        patch
        perl
        powerline-go
        procps
        pv
        rsync
        screen
        skopeo
        socat
        starship
        unzip
        vim
        wget
        xz
        yq
      ];
    };
  };
}
