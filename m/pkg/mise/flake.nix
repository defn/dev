{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-jzHJc9G7/hDfl/BJmdMJdKa7cvmiRKGQ7yZVDNAV4MQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-lnoGe5xnZTUc5zI5BTdXRdwWcOBqsP2HFCU6ccKhR5g="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-ucWQuS9vycbFfcNE4TBcRIVpGrvT1tPcv6X7wMb07NI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-IMG2LVnxQW7e5xvI2QDyM1jDC7NhzXELyXCT9rtopPA="; # aarch64-darwin
      };
    };
  };
}
