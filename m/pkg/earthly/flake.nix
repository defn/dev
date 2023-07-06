{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-pKdmiYtUJHBQ4v7ApJk32PO+3a4Lb+4j4lmnpEY6u+c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-V6mIbNNnUqmxlPtrZIbvrXk2UK+t2HAL9rkWujp31Tk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-xM9B9RUKv1x5Mcnih7BolXDG3TsRtMlilRTxPT0HDIM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-d7Y8VCCg9ZV7HbUokRT9RpFwPMxu6QmNeaAY9h799IE="; # aarch64-darwin
      };
    };
  };
}
