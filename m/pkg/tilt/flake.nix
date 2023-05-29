{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-6bs2m6nd1mZsZ9aC/HM4coVZOoWLI9alXoy+zry9Ptc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-lzENjSK9kAhkFjCPXo37AyFy/6IRjQsVSPng5a7pul8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-CcovQeU/A5MGZUtrttUz8x14oLyg4wuaylKjrPhMK0E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-hKN5V9V7GENZaWk+nOPesL0jOoAjTndtWk+whC0MGS8="; # aarch64-darwin
      };
    };
  };
}
