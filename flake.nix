{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    dev.url = github:defn/pkg?dir=dev&ref=v0.0.14;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
    kubectl.url = github:defn/pkg?dir=kubectl&ref=v0.0.1;
    argocd.url = github:defn/pkg?dir=argocd&ref=v0.0.2;
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
      values = import ./values.nix { inherit pkgs; inherit system; };
    in
    rec {
      devShell =
        let
          inputsList = (inputs.nixpkgs.lib.attrsets.mapAttrsToList (name: value: value) inputs);
          hasDefaultPackage = (item: acc:
            acc ++
            (
              if item ? ${"defaultPackage"}
              then [ item.defaultPackage.${system} ]
              else [ ]
            ));
        in
        pkgs.mkShell
          rec {
            buildInputs =
              values.buildInputs
              ++ [ inputs.self.defaultPackage.${system} ]
              ++ inputs.nixpkgs.lib.lists.foldr hasDefaultPackage [ ] inputsList;
          };

      defaultPackage = values.defaultPackage;
    });
}
