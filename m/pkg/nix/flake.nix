{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-nix"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        direnv
        nix
        nix-direnv
        nixpkgs-fmt
      ];
    };
  };
}
