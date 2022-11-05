{
  description = "protoc";

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

          slug = "protoc";
          version = "3.20.1";
          arch = "x86_64"; # aarch64

          src = pkgs.fetchurl {
            url = "https://github.com/protocolbuffers/protobuf/releases/download/v${version}/protoc-${version}-linux-${arch}.zip";
            sha256 = "sha256-Og6QD5VW+8rEw6kToA0HaA8P32uZCjQUYtgiJHsmVWI=";
          };

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 protoc $out/bin/protoc
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
