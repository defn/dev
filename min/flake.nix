{
  inputs = {
    dev.url = github:defn/pkg?dir=dev&ref=v0.0.22;
    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
  };

  outputs = inputs:
    inputs.dev.wrapper.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.dev.wrapper.nixpkgs { inherit system; };
        wrap = inputs.dev.wrapper.wrap { other = inputs; inherit system; };
        buildInputs = [
          pkgs.rsync
        ];
        site = import ./config.nix;
      in
      with site;
      rec {
        devShell = wrap.devShell;
        defaultPackage = pkgs.stdenv.mkDerivation
          rec {
            name = "${slug}-${version}";

            dontUnpack = true;

            installPhase = "mkdir -p $out";

            propagatedBuildInputs = buildInputs;

            meta = with pkgs.lib; with site; {
              inherit homepage;
              inherit description;
              platforms = platforms.linux;
            };
          };
      }
    );
}
