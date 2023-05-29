{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-/zWqlrVAN9SS0woh3OjZbUdpOnYUh/mFUddQQHwnwoU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-CYl1Je/N+KPQaGh7XVEuBv4r9q6oS6VKKTn4nRT291Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-8Ivsnr+0yDUW3+YqLrHCVWOLfYUWNwNDWxYpb53FHRc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-e0Yga+SWvbI/G5oTgj3HXqc0XpXXj5rP3RB2P5oXjkA="; # aarch64-darwin
      };
    };
  };
}
