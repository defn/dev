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
        sha256 = "sha256-8m3B4pJSgj2hpJuFJcdkz2B3eFrMvKZj520sxQBk77Q="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-I2xs+L7u2R4dkhqycPz82x173bHvjzqhG8w4809KazM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-ovk118VXwJ54rcfwXz+xJfft/rd1dMqId7JLvKZiow8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-cEYnJBGqkRJBd+L16PrX6T2kRl4kuvuw9TlYTlhJrNU="; # aarch64-darwin
      };
    };
  };
}
