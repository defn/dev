{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/smallstep/cli/releases/download/v${input.vendor}/step_${input.os}_${input.vendor}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/step $out/bin/step
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-0eEFQ9bDpdAg37IVM0QpNRLS9edq7hUdBAIGSxnuVYk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-h+jt2Hbri/XBz7t4a26g4iNAQroWyEZMRik108411GE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-pQO0juyw3IkIgelcCL9s3N59N3G+RCCiHFFGdHRXHa8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-eUH2TsatEZ3Q1Cixu+oZSoyeEEGS3WeRHXmgIB30cAI="; # aarch64-darwin
      };
    };
  };
}
