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
        sha256 = "sha256-eyZ+dVWlxaWuVqr93LkGWr2RWwmKhkZ0+FWZY7bMCp8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-ISIvEFnXK8li0BOgXyQRELezK6MhpY7LXtNR/qzmGTM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-+J/K0RV60JPFhlkAiw/m9h4/+ROnr0u8CHPfmlk8Wgg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-YXyZvsuBi9yH1ie3edutnAnQtgXair32MJj03uvC8AY="; # aarch64-darwin
      };
    };
  };
}
