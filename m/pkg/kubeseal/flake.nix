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
        sha256 = "sha256-J8klY1WTs0e3DBzuPpyPOKN0ygxZmyRvutQDU5OT9Gc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-phorMd5essLJQ/EtDY3I/WGWi+bBYHj8nmjqCRtLBdY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-M/w94QiCmd6ffeDzUYlN3wIPkEIKT47nCEl8qK7boec="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-we12UZHONk4mizgLXjfbl7I2pMjlPb3xzCa0D2sL6Jg="; # aarch64-darwin
      };
    };
  };
}
