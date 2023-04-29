{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/gruntwork-io/cloud-nuke/releases/download/v${input.vendor}/cloud-nuke_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cloud-nuke
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-nZRHNOXSEeyOv1Na+ukcDvdMk33GOmJisGlMK/7EBPw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-gMEGVuRhcDV3HXgI4PrfquR82zqFGb5YBkP6JjsiA6Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fyeZeS4jjAKgJQD2CRyRJ4pTHNjwR1rnHCzUnQGlFU8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Ff4cmO4fw9m7LkkJ1TOtf4gcSJiO68nAAHAZP5hgRa0="; # aarch64-darwin
      };
    };
  };
}
