{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    acme.url = github:defn/dev/pkg-acme-3.0.7-5?dir=m/pkg/acme;
    vpn.url = github:defn/dev/pkg-vpn-0.0.90?dir=m/pkg/vpn;
    openfga.url = github:defn/dev/pkg-openfga-0.2.7-1?dir=m/pkg/openfga;
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
        gnupg
        pinentry
        aws-vault
        inputs.acme.defaultPackage.${ctx.system}
        inputs.vpn.defaultPackage.${ctx.system}
        inputs.openfga.defaultPackage.${ctx.system}
      ];
    };
  };
}
