{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/buildtools/releases/download/v${input.vendor}/buildifier-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildifier
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-QveY7FMsWONEAZhQQ+ZgyxnVrplOEI0ZKYx9IpVH/8o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-agOhz1JQRctob8Z81dZM+s5QkuvvyjxMk/tul8ZOB9s="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-PDajIXvXk4FakHqOW/gcKR4tNdc8YHORRkCl9C5l9z8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-m7NmQy1RWBR2avz2+QEClME4dmhvu+WF1da0/wyj6YI="; # aarch64-darwin
      };
    };
  };
}
