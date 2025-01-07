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
        sha256 = "sha256-a/4BAUkMiEgB4RsiDQjlLcijJbt1aQCKlT66XvA5Urk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-1c48aS7g1s5qiYFF3mdzLBrwRFpjeHLD/pXsBVDsMOo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-uZfyAhBsGVTaH7ZR1t7qOWChWzSjZxCX4jBpWaOxoxM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-7sylHN7qyi/kpWjvuZWUk/AEavtArO1mdfY6WPnlD0Y="; # aarch64-darwin
      };
    };
  };
}
