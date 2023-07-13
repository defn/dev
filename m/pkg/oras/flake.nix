{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/oras-project/oras/releases/download/v${input.vendor}/oras_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 oras $out/bin/oras
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-hTPJ6h5aDV6x38UJTA6O8QbRVGL4oRkHdUj4iTftITM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-MyunTAQ+1ZCrD7YWVubSdCQ+kVyxUNSL5K1k7VkdzIQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-O84ag/tRjHvAr6xoVgGDXlI02qiLMHSq/s92jsgCKf4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-AWiguCicICudzVf7T6NjhhAkX9VXQDLhixGWog5BANE="; # aarch64-darwin
      };
    };
  };
}
