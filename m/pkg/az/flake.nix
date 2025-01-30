{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-az"; };

    defaultPackage = ctx: ctx.wrap.bashBuilder {
      inherit src;

      propagatedBuildInputs = with ctx.pkgs; [
      ];

      installPhase = ''
        mkdir -p $out/bin
        cp -a $src/bin/* $out/bin/
        chmod 755 $out/bin/*
      '';
    };
  };
}
