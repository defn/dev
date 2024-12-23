{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-bazelisk"; };

    url_template = input: "https://github.com/bazelbuild/bazelisk/releases/download/v${input.vendor}/bazelisk-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/bazelisk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-/Y/f9BihdYiHUg+kLafmrjmu/HiM9ef3u422k00nn8Q="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-TI2WbkCsLE78x/Glpczu8sCi8WuVfnkfp6hnzOMej8s="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-CvAZ7rZC+nB0RBnQKqMt9V5ueghBBdSfsmgBpmCqVtM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-sT3YnG7NkJRMo1OfWixxWhj2m3RYh4xHGpAqjkgs60s="; # aarch64-darwin
      };
    };
  };
}
