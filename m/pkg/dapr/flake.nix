{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dapr"; };

    url_template = input: "https://github.com/dapr/cli/releases/download/v${input.vendor}/dapr_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dapr $out/bin/dapr
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-LihxWxR2foebyG0ccrVrfiNCogvA1Xdac7B/scC7law="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-RKwItNPGpTcNqilD6/es1WTsHVNh9V+SrpHExOXZ4DU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-YA+t7EON2VSTmJooElSfJctnLOuDzEvV4wfsqTHrQ8c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Bdz4tliy2oEhQOl9soaB+lbcugEatfKSkgy8ln2tE9A="; # aarch64-darwin
      };
    };
  };
}
