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
        sha256 = "sha256-p3sn5f0tZQyqpgy3989FwWmn8CbrasazPN+53CoHjKQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-49TYexuIP8bJJn35KDFKVxhROy5Vs5yMaEaRnglDmv8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "64";
        sha256 = "sha256-cmftifo1p8Jn7qO0UuSEWuXqtaQ0ODocvvJwAL0knxs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Sztg38tL9mX5jLdyg/Lzok4Mv/B7ZiqC2Cb3PxDPLuA="; # aarch64-darwin
      };
    };
  };
}
