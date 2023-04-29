{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://releases.hashicorp.com/nomad/${input.vendor}/nomad_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 nomad $out/bin/nomad
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-kqHS1Fk9CeCDj3/8cRJUlKaZUdIg/6FlgZLH++cDRXM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HoPBH+WNkaoenUrCGEkFRkt2ArouBX3Kl/QBMiXa2LY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-QA8JNzR1QzHDJ++qt+uNPL8skYmfns4uRx+f13/Z+7k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-IwRLj78fBGEgYIQ6tDktCLLinAmUGNJAo6x7VZrxxG4="; # aarch64-darwin
      };
    };
  };
}
