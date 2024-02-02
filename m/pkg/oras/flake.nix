{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-oras"; };

    url_template = input: "https://github.com/oras-project/oras/releases/download/v${input.vendor}/oras_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 oras $out/bin/oras
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-4J6FMjskzMggmhUG8ULj1IHm6AkBhTfGs9uXnIkeatc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-5FCwgfZ/b9ovFrcEYHXGfJpT8/2pL9IOzFmHOxBHerQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-+Kxd6lPdkzHPCA8QJfBhLnsHxa+GSk/WCfl9iUZQjkU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-1S0xQLC7n31+Mdy/KlE/lxQTdpwR99elWZ52zJjkUAc="; # aarch64-darwin
      };
    };
  };
}
