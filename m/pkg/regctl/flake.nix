{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regctl"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regctl-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-5UEyfRTI5tOi5LDf12BGQloYFoedT1lRBCeRQ13sguM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-fD12CSUFL33qSqJrMn6diPOuMPrazBEK4DvQbfP7aW8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-kW4XAZw2/1N1Va2ZiesfzaB0A5BLxw+AjO6e2WWNQQc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-KIM7LwtCJX5wO/db+rfdW661LUpuOtjn0z91Sza4uwc="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regctl
    '';
  };
}
