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
        sha256 = "sha256-x7QO1TwjeAERshUeJIDb2Es0TaZTOrrIkD+7r8P7Res="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-9vAQ2NCa8UCo3AIlCm3zXQnIYU8KNteVDqyh1M3n+rk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-jWtI3wjMF8YqTJc5DptQ203x3dihN6apaXX25AxxPkU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-xS9maDRamF3YKLdf5Jtl38dlZy/iPkWn3QopuV2ErCc="; # aarch64-darwin
      };
    };
  };
}
