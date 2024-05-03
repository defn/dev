{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-stern"; };

    url_template = input: "https://github.com/stern/stern/releases/download/v${input.vendor}/stern_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 stern $out/bin/stern
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-NtYhN/f+O2V5rQWQtLXm6+Hw7cwkMsp8QNnSiqsXsKc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-iWErcCi5B/FQfCRqLNgPRvN2J0VcJXIYNhON3SbVmHM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-R4a/sxBjNy2a7kbbiB8CxblgQFdFsk52FvEXd3WHbig="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-EvL1FmmcYIDYwdEIyqg0WQdw57+MxHMDBGQkVKfbKWc="; # aarch64-darwin
      };
    };
  };
}
