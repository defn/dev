{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/argoproj/argo-cd/releases/download/v${input.vendor}/argocd-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/argocd
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-gfdVG3L3q5+DTYhx4Ya7aucAAPp6U/WSljeMkhd5/S0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-A+ZJSDqOEh5PrIcSfuMkhcfyZJn77ZQHOFIs26AL0g8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-No5PcxL9Nd+Wy1me8Dut+PYg2DHr/yDZ6T4D3wNZBsg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-JRjnyhxdFy2NxQJgVP76OfGnihKHSrq/E4Y9FYWO7Bg="; # aarch64-darwin
      };
    };
  };
}
