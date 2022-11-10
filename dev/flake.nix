{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";
    flake-utils.url = "github:numtide/flake-utils";
    cue-pkg.url = github:defn/pkg?dir=cue&ref=v0.0.2;
    tilt-pkg.url = github:defn/pkg?dir=tilt&ref=v0.0.4;
    earthly-pkg.url = github:defn/pkg?dir=earthly&ref=v0.0.5;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , cue-pkg
    , tilt-pkg
    , earthly-pkg
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      cue = cue-pkg.defaultPackage.${system};
      tilt = tilt-pkg.defaultPackage.${system};
      earthly = earthly-pkg.defaultPackage.${system};
    in
    {
      defaultPackage =
        with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          name = "${slug}-${version}";

          slug = "home";
          version = "0.0.1";

          dontUnpack = true;

          installPhase = "mkdir -p $out";

          propagatedBuildInputs = with pkgs; [
            jq
            fzf
            docker
            docker-credential-helpers
            pass
            kubectl
            k9s
            cue
            tilt
            earthly
          ];

          meta = with lib;
            {
              homepage = "https://defn.sh/${slug}";
              description = "packaging binaries with flake";
              platforms = platforms.linux;
            };
        };
    });
}
