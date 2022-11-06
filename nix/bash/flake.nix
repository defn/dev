{
  description = "c: bash script example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    cuePkg.url = "github:defn/pkg?dir=cue";
  };

  outputs = { self, nixpkgs, cuePkg, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        cue = cuePkg.defaultPackage.${system};
      in
      {
        devShell =
          pkgs.mkShell rec {
            buildInputs = with pkgs; [
              cue
              self.defaultPackage.${system}
            ];
          };

        defaultPackage =
          with import nixpkgs { inherit system; };
          stdenv.mkDerivation rec {
            name = "c-${version}";

            version = "0.0.1";

            src = ./run.sh;

            dontUnpack = true;

            buildInputs = [ cue wget ];

            installPhase = ''
              install -m 0755 -D $src $out/bin/c
              chmod 755 $out/bin/c
            '';

            meta = with lib; {
              homepage = "https://defn.sh/c";
              description = "containerizing scripts with flake";
              platforms = platforms.linux;
            };
          };
      }
    );
}
