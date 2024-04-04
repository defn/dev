{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cue"; };

    url_template = input: "https://github.com/cue-lang/cue/releases/download/v${input.vendor}/cue_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cue $out/bin/cue
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-/5NJ8zAqWbmfuErUwm9BApYXa5VcKLyQKRHrIf1N6ZI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-kRYdlEghUpYPV0+Tvyspmer9eLuEHT4ITyB0wod7mlw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-4/k8EBn5pW039Yb5ZhaCVMVAfvg9fJrZXgVlu4KH3xY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-lNkAa6/WIULEa/TLRMhCBf9djiMkMq/BJgAUMfwA4uI="; # aarch64-darwin
      };
    };
  };
}
