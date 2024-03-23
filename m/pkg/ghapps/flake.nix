{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/nabeken/go-github-apps/releases/download/v${input.vendor}/go-github-apps_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 go-github-apps $out/bin/go-github-apps
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-5imd3wU8SfiLZbTXHKECcTyB/qwUgmST2LETYj3meT8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-DuYQlq0Fl6PCSVN2Xxf8bRHItP+La3kGfsv130oR3sI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-eLz9DzbCeSNCLpu6FKSyfDQPJCkJXmv+715Cu9/La0I="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-57UU0fDFrxu4UyA0sgVRjT7JspKzB3jWzSV5XTJ9aPM="; # aarch64-darwin
      };
    };
  };
}
