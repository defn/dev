{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-secrets"; };

    packages = ctx: {
      pass = ctx.pkgs.writeShellScriptBin "pass" ''
        { ${ctx.pkgs.pass}/bin/pass "$@" 2>&1 1>&3 3>&- | grep -v 'problem with fast path key listing'; } 3>&1 1>&2 | cat
      '';
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        (packages ctx).pass
        pinentry
        aws-vault
      ];
    };
  };
}
