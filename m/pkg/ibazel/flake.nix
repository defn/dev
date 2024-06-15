{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-ibazel"; };

    url_template = input: "https://github.com/bazelbuild/bazel-watcher/releases/download/v${input.vendor}/ibazel_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/ibazel
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-E3fK+IenojkQatZAj8oeFN+yObMHKzq927Zg/5lLYqo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-PBWvFf/nf3xO15mmp8U5VBkipIEbi59PusBEBg74m2Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-5NXgSioOTdohNQ/+JmI0aahauHhlcK6pYrBYqVTc0/E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-5NXgSioOTdohNQ/+JmI0aahauHhlcK6pYrBYqVTc0/E="; # aarch64-darwin
      };
    };
  };
}
