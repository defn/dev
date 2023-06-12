{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-TL6efHWW+ez9CcX/nmf+qF6gC7XIr7sP1cBtnVnb2QM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-oi1gRDT/0+bQ6+4iekGMO1pzHpIkLSCvGF24kdUNaRM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-19fmUokYjnLNcQMq2ST1hYOQZaGl+1Q1hEX4pofz/Zc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-kVflwq0jG3GQz34nMZNabYtt6+OTWb2P3SK0+P2eAYY="; # aarch64-darwin
      };
    };
  };
}
