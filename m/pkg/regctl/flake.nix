{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regctl"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regctl-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-l1ND/2Nosar/VmP0lfkMxSuL3UXjOdbJpLzQOMhlI4I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-6U3FM6/jJgKsm/Ciw2Qq4f1s3L5G382ZEllNb8mdkBs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-7yaWNBm2UZxk6iIBcG5QxFvoCRgD9+7Z1t5DdXVj+G0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-WGComw33t0UQqmqBLMeuiEq7SzNgoELlOjMdr3aTvVU="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regctl
    '';
  };
}
