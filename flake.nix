{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
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
          pkgs.nixpkgs-fmt
          github:defn/pkg?dir=tilt&ref=v0.0.2
          github:defn/pkg?dir=caddy&ref=v0.0.1
          github:defn/pkg?dir=temporalite&ref=v0.0.1
          github:defn/pkg?dir=kubectl&ref=v0.0.1
          github:defn/pkg?dir=cue&ref=v0.0.2
        ];
      };
    });
}
