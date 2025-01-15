{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */gum $out/bin/gum
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-l+rQzKtDIKwxC/ajtkl91I5YPLp9c/xyPn0LTpTaZ5k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-MHvXjuEucmX6KXHbbr+cr1bP7C8HytZuBE1ADXvNyQU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-z7CBfH75ettwPsyUahUKLbijqoR8WJbCoyNwFDlsX2k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-gsXUYOW6E2a+JqiQu5J19TNsf7pAM3bMwkaqtcGe1+o="; # aarch64-darwin
      };
    };
  };
}
