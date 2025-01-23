{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/openfga/cli/releases/download/v${input.vendor}/fga_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 fga $out/bin/fga
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-jAiDxyAnOQ2QxFT+X3ZjYqqQyDV5RTyXk30JvPJcGXA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-qzfimSYRMDH1eIw9zuxRgRuIm/7U39ykRAWcbsSSz8A="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-/1irin4bU6I49+rTVwRS32p3WoGBt6VecRgK2dsXqVk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-/1irin4bU6I49+rTVwRS32p3WoGBt6VecRgK2dsXqVk="; # aarch64-darwin
      };
    };
  };
}
