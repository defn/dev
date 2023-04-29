{
  inputs = {
    pkg.url = github:devn/dev/pkg-pkg-0.0.6?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        xz
        unzip
        rsync
        dnsutils
        nettools
        htop
        wget
        curl
        procps
      ];
    };
  };
}
