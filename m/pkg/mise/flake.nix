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
        sha256 = "sha256-TFv0GTObnE8SG0hUsSavtfkXDLohUiO0xorIuKfIrW0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-799+tpX/LGOVGm9cbbZPhKivdlijRFGTzJFbS4A7u4w="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x64";
        sha256 = "sha256-aaaaalMYIIWxWV25w5SY2pd2970Ffa51UJ1zuTWhJ7I="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-aaaaalzfgXzIsz8483omh11bRjIeB7ZERhbixdYmZjA="; # aarch64-darwin
      };
    };
  };
}
