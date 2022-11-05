{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    aws-signing-helper-pkg.url = "path:./nix/aws-signing-helper";
  };

  outputs = { self, nixpkgs, flake-utils, aws-signing-helper-pkg }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        aws-signing-helper = aws-signing-helper-pkg.defaultPackage.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.go
            pkgs.gotools
            pkgs.go-tools
            pkgs.golangci-lint
            pkgs.gopls
            pkgs.go-outline
            pkgs.gopkgs
            pkgs.delve
            pkgs.nodejs-18_x
            aws-signing-helper
          ];
        };
      }
    );
}
