{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dyff"; };

    url_template = input: "https://github.com/homeport/dyff/releases/download/v${input.vendor}/dyff_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dyff $out/bin/dyff
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-86H0xcM46AwTzt4daYQ0xmGAzHBPdJUoc0c/kaEc/XU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Yb30p0X1qu40c8t6m7lowsk4N/9iyfoX4H0cFqskT8Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-mN3naO1FgxMuO2KgHEOQhCfN4VMp+P+AFWSbAFHS5yY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-QqT9oH33sQCkaFGOp3SFgjtvcBT7RxKSQ/y/E9oPGEI="; # aarch64-darwin
      };
    };
  };
}
