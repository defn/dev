{
  description = "buf";

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

          slug = "buf";
          version = "1.9.0";
          arch = "x86_64"; # aarch64

          src = pkgs.fetchurl {
            url = "https://github.com/bufbuild/buf/releases/download/v${version}/buf-Linux-${arch}.tar.gz";
            sha256 = "sha256-bB5yWLeSc8YAhd+IJaUqXuMGUw5zJ5QskeyEVFzS1Ao=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 buf $out/bin/buf
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
