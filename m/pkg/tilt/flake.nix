{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-tilt"; };

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-E1DxiGkEiS4jalVvJ1otxeP6agH9jDggLNaRE68goK4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-nRSY8sTdeepsRLmFzUOL1CrlF6MfeRu+Tafmlv7EIvk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-wOzVTQquafKffNQbm7TgVbcKMD3+36onDMFCbHkxyrE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-gLZqnd0u2mQW9kVGBcJ8G0WD2UuBTlpptd49wTg/e44="; # aarch64-darwin
      };
    };
  };
}
