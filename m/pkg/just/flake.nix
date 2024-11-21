{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-just"; };

    url_template = input: "https://github.com/casey/just/releases/download/${input.vendor}/just-${input.vendor}-${input.arch}-${input.os}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "unknown-linux-musl";
        arch = "x86_64";
        sha256 = "sha256-njAdoaRhU7TJrfnv4g0FNhRntVkbGzz4iA21mh0BmWM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "unknown-linux-musl";
        arch = "aarch64";
        sha256 = "sha256-lqde017yyyJ9kh+nHNjI37WCjKGX4nQMqGJlRtOTsE4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "apple-darwin";
        arch = "x86_64";
        sha256 = "sha256-vptQO+nFCigLkkMQNa3CCmSoTdGIn5e04vKETHdlD8c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "apple-darwin";
        arch = "aarch64";
        sha256 = "sha256-YTp8ljmPzMwqUzSmO7Ul6GXnSr7ijQ3xhpgkqMDA2+s="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 just $out/bin/just
    '';
  };
}
