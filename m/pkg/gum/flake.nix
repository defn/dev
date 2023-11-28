{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 gum $out/bin/gum
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-V5uUhU/0DvwL6LbyLQpz7NfVkwd5J0LPtlLTXVnLx4I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-one9SzMyOT3Mel7zOl3qkOvey49EUOyC4Cg3PJ2Kziw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-miXRG+KZI86JJL2+Ws3oJ75zY5ARywAbXkcrC+/L9sE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-lS6kaxN9atYT0ISfyGI8zLSPHiQ5LhNZiRIHh1GNu4w="; # aarch64-darwin
      };
    };
  };
}
