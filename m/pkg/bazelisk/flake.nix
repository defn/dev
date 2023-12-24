{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/bazelisk/releases/download/v${input.vendor}/bazelisk-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/bazelisk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-0otYisCRar1r8C3vtUM/bt33y6Nf+oCOq7ZaRKqyJvc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-hhoWupl5YT5wvT0vnZq147Wf55RxxXU6zcnEMatsnZQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-8rpfchqZW1S6toxrdqNAcZiIqnQDEOY0dxCGttFSjs0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-afohzSzP/C8JcMIao2FUhLqJ41U+zOEjOp2K2VcNFw4="; # aarch64-darwin
      };
    };
  };
}
