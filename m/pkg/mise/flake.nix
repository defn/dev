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
        sha256 = "sha256-pfOAqgfR0nmszELxdtxLesS+VQ+TjH5MPHMm1586XJs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-JILIVkjzn77lJLvticWGAFXKfJ6uwsIS/64VkxM/ysk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-YYRcw7Ld9aKaWBqsCUBzHGKw7t3NJs3g1/CjkstFJRE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-Ph11rGHbyn7YnXQECY0V7wtjMZmKJw1/yDUHlcR9IjY="; # aarch64-darwin
      };
    };
  };
}
