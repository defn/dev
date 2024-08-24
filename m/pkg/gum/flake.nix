{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */gum $out/bin/gum
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-YXkUQx4gRz/WsJexI7Lg3tq6ip0q6ftZ6utCBqlcM4E="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-T5N+uOBsSQPOSioNaidK+8unf9E76i9kjGE+wuPRoto="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-MAulClLrpf8rrjEktIGOzW5JRsti9YWfUdBZMANY4Os="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-oKeGfyvUxh7Nl/rrLLngpO7y7EwJpp1DzI/KO433ppg="; # aarch64-darwin
      };
    };
  };
}
