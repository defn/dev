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
        sha256 = "sha256-ZIqh7lP5uYGd+pEtrqAc6hgwjgPN58zkaKDqyeLEIDc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-s52MftZorueI4aoYjyxrvc+xHp2G8GUTBPvRJqkA3Fc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-ZgtFzCdO5GNDK0H1vBnhMF9EItOsMmU8Lm5oyWRSS3o="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-Zb6tRXpbGgE/ESztYBSEh7UUr9UFPaoEj9thPg7lK5I="; # aarch64-darwin
      };
    };
  };
}
