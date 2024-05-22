{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-terraform"; };

    url_template = input: "https://releases.hashicorp.com/terraform/${input.vendor}/terraform_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 terraform $out/bin/terraform
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-EhZ1dK4N6yGaEAi9TBX/E9rHGY1Xhw9IQz1T/isLKMQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dmaOd0Luj4Ff5t4oyLhFB+YXGyaWZCbC647qjmT+LzM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-WWiHKwdneCkALQp600zwxM0CiTocEx5MowI2RCzuxEU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-alTShiyCRP6+YHeh/G6ebMTmXu6BaQSed84I3yM89Jo="; # aarch64-darwin
      };
    };
  };
}
