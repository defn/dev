{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cilium"; };

    url_template = input: "https://github.com/cilium/cilium-cli/releases/download/v${input.vendor}/cilium-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cilium $out/bin/cilium
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-oaCfPwF24RixsAvk/Nf58y8nyVh8ZLVXnSdH11HnLiM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-SwX7FmG2me3YnzcSTVzQqk9dz8GXzvagvHpvqj3BGdQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-wnouVMKyZ+C4c7if1pScMZsJK45MHlvoMLudOVmRHzY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-IfDaCv7EmrCewMUPCQ3PmulyeJF8Xpk/9ONuSKZo0l0="; # aarch64-darwin
      };
    };
  };
}
