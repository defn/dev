{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/earthly/earthly/releases/download/v${input.vendor}/earthly-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/earthly
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-qef0JdQxvo7TOERCr2H26sBfnZ+fZ9ypd9syepXItDo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-XL3wTjUNLrKDosmSQ1X1KfGnvCXObl+a1n9FXwP1dww="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Ujswkuq3ajC4rUiaJnYUsKIFR3b/8VSKL/ocLDwOEd0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ZgphHVilM47Jl8jvlSuiIuQ4Xv2iqYam4HhBiEJn2HQ="; # aarch64-darwin
      };
    };
  };
}
