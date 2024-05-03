{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-zellij"; };

    url_template = input:
      if input.os == "darwin" then
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-apple-${input.os}.tar.gz"
      else
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-unknown-${input.os}-musl.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 zellij $out/bin/zellij
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-qf0+8tm7L9gp4M4CTpsNcYuLUUDeYZRITMERDtMkNw8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-DfDWa0mQMQgoyHCX8KiYGRhK7h8JulH07Flj+uUfzTE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-1ko3erdtSWCYGinjNVdlFpwOEy0Zkn0yOFgZoCRPHvA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "aarch64";
        sha256 = "sha256-Mm8rPuFWm2m6LfP/xForOo0WjAlnKxhsumBzoAgQ93w="; # aarch64-darwin
      };
    };
  };
}
