{
  description = "sup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.05";
  };

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation rec {
        name = "sup-${version}";

        version = "9.0.0";

        src = pkgs.fetchurl {
            url = "https://github.com/tilt-dev/tilt/releases/download/v0.30.10/tilt.0.30.10.linux.x86_64.tar.gz";
            sha256 = "67133d806f900eef0a36665b39b8c9ef7d70eacb0f4876ede3ce627049aaa6cf";
        };

        sourceRoot = ".";

        installPhase = ''
            install -m 0755 -D tilt $out/bin/sup
            '';

        meta = with lib; {
          homepage = "https://defn.sh/sup";
          description = "packaging binaries with flake";
          platforms = platforms.linux;
        };
      };
  };
}
