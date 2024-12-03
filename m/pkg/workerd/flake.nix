{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-workerd"; };

    url_template = input: "https://github.com/cloudflare/workerd/releases/download/v${input.vendor}/workerd-${input.os}-${input.arch}.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      fname="$(echo $src | sed 's#.gz$##')"
      if ! test -f $fname; then
        zcat $src > workerd
        fname=workerd
      fi
      install -m 0755 $fname $out/bin/workerd
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "64";
        sha256 = "sha256-gLgXIz2l2V+TshWyk08Br9t/mcFEl0vrKEYAQTVpNBA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-2zJRlYtJlhd3tNvmy1hle4STuKiEk0NJ6D8hN2L4oLc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "64";
        sha256 = "sha256-YeVQiI0VGL8sG2XuHwKXbj47EUzTm7zeNmFQjQEdYNo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-rYyDm51qLEW12omRPPUk+2fyE8WD7zDbHzPytIL7Kwc="; # aarch64-darwin
      };
    };
  };
}
