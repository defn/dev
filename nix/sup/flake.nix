{
  description = "sup";

  inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/22.05";
     foopkg.url = "path:../foo";
     flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, foopkg, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          foo = foopkg.defaultPackage.${system};
          lib =  nixpkgs.lib;

      in {
        devShell = pkgs.mkShell rec {
          buildInputs = [
            foo
          ];
        };
      });
}
