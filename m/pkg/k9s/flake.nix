{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-k9s"; };

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-P1+ls1Y88pYuzXg4HfWacqAdgk2H88cEk/d0iAckN1U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-3+C7eOF6S3L/FR4Y5UhGe2BzYI4a9OLvswqITu13LqA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-1lR6K83+HIzQJOw7kUUQizdpbvsBma5uILwCE1qjuLo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-4JxecfBTatqTxdbFBWPXvp/6JdJa6zoeUfIith0kh40="; # aarch64-darwin
      };
    };
  };
}
