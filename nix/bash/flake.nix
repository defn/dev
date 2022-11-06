{
  description = "docker example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    caddyPkg.url = "github:defn/pkg?dir=caddy";
  };

  outputs = { self, nixpkgs, caddyPkg, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        caddy = caddyPkg.defaultPackage.${system};
        bash = nixpkgs.bash;
      in
      {
        devShell =
          pkgs.mkShell rec {
            buildInputs = [
              caddy
              bash
              self.defaultPackage.${system}
            ];
          };

        defaultPackage =
          with import nixpkgs { inherit system; };
          stdenv.mkDerivation rec {
            name = "dkr-${version}";

            version = "0.0.1";

            src = ./some-script.sh;

            dontUnpack = true;

            installPhase = ''
              install -m 0755 -D $src $out/bin/dkr
              chmod 755 $out/bin/dkr
            '';

            meta = with lib; {
              homepage = "https://defn.sh/docker";
              description = "packaging binaries with flake";
              platforms = platforms.linux;
            };
          };
      }
    );
}
