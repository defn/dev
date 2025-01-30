{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/traefik/yaegi/releases/download/v${input.vendor}/yaegi_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-OW4wInwhFyMkFHo8YDoESgzA7Yu9pJD9NIMZBf+Xf5Y="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-i93pYY0GOxbH+fQ6eJWTXFiedB10KPyr7R54cNuygDg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-gklG0yBbaefRqnkNm6cstwCvnAOB2n+TNGlmKURc1bY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-hxWlRMpihgCPkQdv6PCJKK5c+l6kl/PyTgul/7MSJfQ="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 yaegi $out/bin/yaegi
    '';
  };
}
