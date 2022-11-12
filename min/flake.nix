{
  inputs = {
    dev.url = github:defn/pkg?dir=dev&ref=v0.0.29;
  };

  outputs = inputs:
    inputs.dev.wrapper.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.dev.wrapper.nixpkgs { inherit system; };
        wrap = inputs.dev.wrapper.wrap { other = inputs; inherit system; };
        buildInputs = [
        ];
        site = import ./config.nix;
      in
      with site;
      rec {
        devShell = wrap.devShell;
        defaultPackage = pkgs.stdenv.mkDerivation
          rec {
            name = "${slug}-${version}";

            src = with downloads.${system}; pkgs.fetchurl {
              url = site.url_template downloads.${system};
              inherit sha256;
            };

            sourceRoot = ".";

            installPhase = ''
              install -m 0755 -d $out/bin
              install -m 0755 gum $out/bin/gum
            '';

            meta = with pkgs.lib; with site; {
              inherit homepage;
              inherit description;
              platforms = platforms.linux;
            };
          };
      }
    );
}
