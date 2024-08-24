{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-glow"; };

    url_template = input: "https://github.com/charmbracelet/glow/releases/download/v${input.vendor}/glow_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */glow $out/bin/glow
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-wWBn/BZFUhHZojnpMbAJgvuIOu9LLInPowqZLvIFiuU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-aTF6OT7o5sZOLrSXGNBT1dmOG/Pme4noll6tDosSAEw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-ZNiSynhmdS8mByLKg/knRkRqA+czztvCiXw1OVGr4nQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-BBdeDn6Un9Wgo0DLsRvgV8BK58SeqF8GZ5pxNAzEvLY="; # aarch64-darwin
      };
    };
  };
}
