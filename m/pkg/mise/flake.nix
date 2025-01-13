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
        sha256 = "sha256-cBXtH0DDiuYkMesW350jXYs2F5C8jOHEmmuMlDzxzD8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-xPzQdMgwPkYcOLkNYmSrtDDU6AmpJhLwZel1NhJXQxo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-sgXw6S29KkeONrULEY6I0GPbJ0mHwiEUC2Csd+mrE9A="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-kBbHkF2eKVI02rnerGrWBTa4ayH5R1Ja7ktEZFeDkQI="; # aarch64-darwin
      };
    };
  };
}
