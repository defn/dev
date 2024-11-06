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
        sha256 = "sha256-zInPLRjbGC4mcVrD363Bgz0286B5/Oqz+/E165ypqI0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-+5GBF18r2zfQoyKLJhOXRLCC/Q3KZefO11yssMtPBzQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-lfIFkdZcnn3TOHIjtWgRpH0Bg9yjuz5m8Ml5oqLxzXY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-A/3xQGL+L+MX//nqOhHAZtm3k6TcowcYxzWkmlMndqA="; # aarch64-darwin
      };
    };
  };
}
