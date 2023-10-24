{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/earthly/earthly/releases/download/v${input.vendor}/earthly-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/earthly
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-n4evfPLJyvjLYGR9IpI0y8KaXs7UY1skFngRbmqLw6g="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-4K37q1VdqI5VOhlu9bBi3UbGJCIf2h6q9ENj5XLnOig="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-dcSXhXu6kW7pv8sI7xL1mz2jl9QiEb7d49NNrx0KCLA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-HET65CZslAxNQ/s2Qlz/g0pPSiss6WF/8Ed2kYnoWIw="; # aarch64-darwin
      };
    };
  };
}
