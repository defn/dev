{
  description = "steampipe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage =
        with import nixpkgs { inherit system; };
        stdenv.mkDerivation rec {
          name = "${slug}-${version}";

          slug = "steampipe";
          version = "0.16.4";
          arch = "amd64"; # arm64

          src = pkgs.fetchurl {
            url = "https://github.com/turbot/steampipe/releases/download/v${version}/steampipe_linux_${arch}.tar.gz";
            sha256 = "sha256-IEdbo/a955elm1j5R3nWsCcnli9FmiL3xNt9N2Y+GPs=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 steampipe $out/bin/steampipe
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
