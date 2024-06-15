{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-hubble"; };

    url_template = input: "https://github.com/cilium/hubble/releases/download/v${input.vendor}/hubble-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 hubble $out/bin/hubble
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-NrrnVq6tNxNzYHrzPDzGAFQj1r1oZtFuqPW+vBIWeSg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-uV+PjHC7oxd3pYgquJpH3PoPgOPr+4Otcaguzhog8eI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-y3iHjugys2VGR+tIqANbi47MwmlBfcI2bOHD0BUpxTg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-cPGMQW0oL0LQQcSlZsItt+Q7gMRiuPcBF6hUuA8g5n0="; # aarch64-darwin
      };
    };
  };
}
