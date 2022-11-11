{
  inputs = { };

  outputs = inputs: {
    wrapper = { other, custom, system, pkgs }:
      let
        values = import custom { inherit pkgs; inherit system; };
        inputsList = (pkgs.lib.attrsets.mapAttrsToList (name: value: value) other);
        hasDefaultPackage = (item: acc:
          acc ++
          (
            if item ? ${"defaultPackage"}
            then [ item.defaultPackage.${system} ]
            else [ ]
          ));
      in
      rec {
        defaultPackage = values.defaultPackage;
        devShell = pkgs.mkShell
          rec {
            buildInputs =
              values.buildInputs
              ++ [ other.self.defaultPackage.${system} ]
              ++ pkgs.lib.lists.foldr hasDefaultPackage [ ] inputsList;
          };
      };
  };
}
