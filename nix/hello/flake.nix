{
  description = "c: bash script example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
              self.defaultPackage.${system}
              cue
              go
              gotools
              go-tools
              golangci-lint
              gopls
              go-outline
              gopkgs
            ];
          };

        defaultPackage =
          with import nixpkgs { inherit system; };
          stdenv.mkDerivation rec {
            name = "hello-${version}";

            version = "0.0.1";

            src = ./dist/cmd.hello/bin;

            dontUnpack = true;

            installPhase = ''
              install -m 0755 -D $src $out/bin/hello
              chmod 755 $out/bin/hello
            '';

            meta = with lib; {
              homepage = "https://defn.sh/hello";
              description = "containerizing golang binaries with flake";
              platforms = platforms.linux;
            };
          };
      });
}
