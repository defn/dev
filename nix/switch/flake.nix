{
  description = "switch";

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

          slug = "switch";
          version = "0.7.2";
          arch = "amd64"; # no arm64

          src = pkgs.fetchurl {
            url = "https://github.com/danielfoehrKn/kubeswitch/releases/download/${version}/switcher_linux_amd64";
            sha256 = "sha256-ivFUE23fVENRzvc586gIglVRWMnk7I5CQbloBgSr1Aw=";
            executable = true;
          };

          sourceRoot = ".";

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 $src $out/bin/switch
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "${slug}";
            platforms = platforms.linux;
          };
        };
    });
}
