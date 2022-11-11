{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/22.05; # nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    dev.url = github:defn/pkg?dir=dev&ref=v0.0.15;
    wrapper.url = github:defn/pkg?dir=wrapper&ref=v0.0.16;

    caddy.url = github:defn/pkg?dir=caddy&ref=v0.0.1;
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        wrap = inputs.wrapper.wrap { other = inputs; inherit system; inherit pkgs; };
        slug = "min";
        version = "0.0.1";
        buildInputs = [
          pkgs.rsync
        ];
      in
      rec {
        devShell = wrap.devShell;
        defaultPackage = pkgs.stdenv.mkDerivation
          rec {
            name = "${slug}-${version}";

            dontUnpack = true;

            installPhase = "mkdir -p $out";

            propagatedBuildInputs = buildInputs;

            meta = with pkgs.lib; {
              homepage = "https://defn.sh/${slug}";
              description = "minimum configuration";
              platforms = platforms.linux;
            };
          };
      }
    );
}
