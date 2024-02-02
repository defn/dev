{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-9D4cM4feJFR1BqsF0k5TCcDOCyKMI72Kpk6exLggZlE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-sp5hZ0cxsV9q09GjEYqZ08wqslqRGq0bisjHLVqdKVI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-gEWGiWSW97Pal/VgieoA8iDgdelptv32wLe5zcIt4SA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-wvNvMomgHHyTyhH4TXQKFw4K8dLQKAvVI6QJpiuN+h0="; # aarch64-darwin
      };
    };
  };
}
