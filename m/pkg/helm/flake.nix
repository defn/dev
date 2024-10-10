{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-helm"; };

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-kxg3m4R+MzRg0z0pHUwIgVYpmibNk9Vwp/XQw25Qtbs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-GIgwGut9CKA7bZ9NK3Pc0JuJxBV36A40VcETYp/GV6Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-M+/UhJLyNYpJojGHPouvQfcCtasFkzOunDHlUXYzwW4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VkE8f7tJbSeJiBA5yrYdhJcnx7NdsAgm+ueiaFpAM0Q="; # aarch64-darwin
      };
    };
  };
}
