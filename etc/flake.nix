{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:defn/dev?dir=dev&ref=v0.0.2";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShell =
        pkgs.mkShell rec {
          buildInputs = with pkgs; [
            home.defaultPackage.${system}
          ];
        };

      defaultPackage =
        with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          name = "${slug}-${version}";

          slug = "TODO";
          version = "0.0.1";

          dontUnpack = true;

          installPhase = "mkdir -p $out";

          propagatedBuildInputs = [
          ];

          meta = with lib;
            {
              homepage = "https://defn.sh/${slug}";
              description = "TODO";
              platforms = platforms.linux;
            };
        };
    });
}
