{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-kubeseal"; };

    url_template = input: "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${input.vendor}/kubeseal-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kubeseal $out/bin/kubeseal
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-AQaaXnntdwK6EL7ULNgTLZR0bKKIrdBoNtCCtCAsJ4k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-burIWePOkkNYxRLFcjRd86GeiPFOB105pXv1TRPiLSI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-10dOFTRAZYvSZUCq3GzmgW4Ur++xWrVK0z5UhpuK8tI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-1CDEkNG1pbPJEue7X6PK/UOxLHPazUMLjZ/2gJIqsKM="; # aarch64-darwin
      };
    };
  };
}
