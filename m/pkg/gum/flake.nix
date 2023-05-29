{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 gum $out/bin/gum
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-79w1ZK/be0t1ZrXKtJ3TuCqpxsmIDC3xVy3/JYTWGMU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-3sR9a+ei+dUBRzRmxnAUdNhkILzjt58Snhk8jCeH7ks="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-Qa9WeLEF0Y3FyXUsimK6Z+VGCYRrMpm2AcFsjuhDmc0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-4evdtTIf5d1X3iH0sO+X0UkVAp8/UxtiV3iuv5ZI/5Y="; # aarch64-darwin
      };
    };
  };
}
