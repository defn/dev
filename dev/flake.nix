{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cue-pkg.url = github:defn/pkg?dir=cue&ref=v0.0.2;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , cue-pkg
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      cue = cue-pkg.defaultPackage.${system};
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

          propagatedBuildInputs = [
            cue
            pkgs.vim
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
