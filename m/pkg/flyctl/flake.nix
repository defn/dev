{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-flyctl"; };

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-1VHR3Q9HxrL9/uHQiZj7xaSJ9CUL1DYjKQTuPe4Xzn8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-Ygg08LF6aPhevsk7TRoO7MYG6S6sB73cPdCGPrSgUsQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-BfABMH5wnYdF4/J/IeR20Y/yxLyDBbEDI0DP0+zZMEo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-h94hO3S5FjD5wUbfbaVsxRa0jap7h4T0oOlMCnGWg1o="; # aarch64-darwin
      };
    };
  };
}
