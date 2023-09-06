{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/alexellis/k3sup/releases/download/${input.vendor}/k3sup${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/k3sup
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "";
        arch = "";
        sha256 = "sha256-AUKM1O3jiT14miv4oyj+jpZ4UeP+J6tB2gpS0c6Ckv8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "";
        arch = "-arm64";
        sha256 = "sha256-1PtQ6xuF31/4VsNNWKckSQLMrPG3TBE3p9a6daJ922E="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "-darwin";
        arch = "";
        sha256 = "sha256-rOjxEKUyvMpv4aCZ582Zt5UsmBvA9s1z0aO7d15Kukc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "-darwin";
        arch = "-arm64";
        sha256 = "sha256-IfwKQRavkFKhRHD6dHYYeTCJN9rbjQp+av2AsvbzO4I="; # aarch64-darwin
      };
    };
  };
}
