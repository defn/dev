{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buildifier"; };

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
        sha256 = "sha256-Yiv5xIMIb5brtIQcUzCK4knK5utM4Xx+Q4tzDXSLJxk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-7iGCiiFy4J96A0c7+0TLkXDbwhNm6IY6GKkEpz7SoSM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fubU4d4qV/GAE+/2LIn+jbYEsydHHXkq9MUlwV5iGPU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-xr52+aqV7es8ydIadHiSyjAHVRPT0f3v+622TBBLQDo="; # aarch64-darwin
      };
    };
  };
}
