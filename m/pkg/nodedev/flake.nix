{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/commits/release-22.11
    latest.url = github:NixOS/nixpkgs?rev=5b0cc6cee71188c29b20fc0de4ea274e24336bc0;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          bashInteractive
          nodejs-18_x
        ];
    };
  };
}
