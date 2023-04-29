{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/buildtools/releases/download/${input.vendor}/buildifier-${input.os}-${input.arch}";

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
        sha256 = "sha256-90zHFWprZ7vd4QT/kEiHtoD9e1nUBY26L6fibdPlrRo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-fT2NhouvOyk1WjoKlG67pMIe232TvZqRq8s8yd72VcM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-M+AuEGtZ7GPLs/Wmt9U0jId4i7VL87zNfE20CIRDbr4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-8DIlc0gj1ApE0DbrRQU/oqsOxhOQpJURv9aNbyaDSBw="; # aarch64-darwin
      };
    };
  };
}
