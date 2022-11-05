{
  description = "aws-signing-helper";

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

          slug = "aws-signing-helper";
          version = "0.0.1";

          src = pkgs.fetchurl {
            url = "https://s3.amazonaws.com/roles-anywhere-credential-helper/CredentialHelper/latest/linux_amd64/aws_signing_helper";
            sha256 = "sha256-WK8NkfuoAdswrlD7lNl4h0PNl96eKYMrZqgY3fnpgHw=";
            executable = true;
          };

          sourceRoot = ".";

          phases = ["installPhase"];

          installPhase = ''
            mkdir -p $out/bin
            install -m 0755 -D $src $out/bin/
          '';

          meta = with lib; {
            homepage = "https://defn.sh/${slug}";
            description = "aws cli helper for aws iam anywhere";
            platforms = platforms.linux;
          };
        };
    });
}
