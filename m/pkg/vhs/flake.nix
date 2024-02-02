{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/charmbracelet/vhs/releases/download/v${input.vendor}/vhs_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 vhs $out/bin/vhs
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-dIRD4LXfiUdUmTMLiUO/ZQzwYnJQKQzVoR0404WeltQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-odNzXtGl+jdFH7Sr8OBtljyr0e0m/VqjWYU+EvFmcbo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-D/FdAu9Sg1EK1UEU0xHwv8Cwn80ddAhUdJBWIm6/ZX0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-Vgq2ya+e/ZQ3t8NTSv7j7S6gptzibm8I2DOFXrQH1Cs="; # aarch64-darwin
      };
    };
  };
}
