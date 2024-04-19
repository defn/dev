{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vcluster"; };

    url_template = input: "https://github.com/kubernetes/minikube/releases/download/v${input.vendor}/minikube-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/minikube
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-S/3Bfw3OZ4Qy1cAsKmgcenKSHLcqqTzMAMESBw7F0rw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-16+0P4cZAzGyruRR7vC65pnJPQrLe1dATMa202mAM6c="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-OqV54JAUwloajoE/PQA+/0UKgJoE8inYnNjtcN6B95E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VImU8CXtNvkbmiT/KCZ0uFNMR0VTXAURu78xEqYDpjI="; # aarch64-darwin
      };
    };
  };
}
