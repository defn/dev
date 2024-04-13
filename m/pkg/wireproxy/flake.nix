{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-wireproxy"; };

    url_template = input: "https://github.com/pufferffish/wireproxy/releases/download/v${input.vendor}/wireproxy_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 wireproxy $out/bin/wireproxy
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-wgPR9MhyYWDjRtP5ynQR4LICm8gYpXzemT7jcRNpvKo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Aifng2YjnWDg4ZU9+6S0aH55MsS3WxSc1uZ+LU5n0XM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Vqt+aUSinzqxq2/K2cDzVHVoEM4e//OPFq5bgAIwsRo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-kLt9FSs5lK4vm5CjZBbKDgk1dpn2EO1KxWjnh4Bq6fE="; # aarch64-darwin
      };
    };
  };
}
