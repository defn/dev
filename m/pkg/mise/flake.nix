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
        sha256 = "sha256-1+WI5axB30hFMbxyMqNg3FFtbnTJu4Ftbp6FxRvnkag="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ekbCRrw+gWK16QCGtqJQgIdbk8v0WYW42offCb4H4z0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-zm63bZumoLdB8jhQLdHSlgpOJ71Kd7XvMWtYIG4rmz0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-1aNvFjbBgZglQqvm20zBVM2kIvnbnxsgJNeBDNdGY1o="; # aarch64-darwin
      };
    };
  };
}
