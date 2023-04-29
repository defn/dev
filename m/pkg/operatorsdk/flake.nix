{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/operator-framework/operator-sdk/releases/download/v${input.vendor}/operator-sdk_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/operator-sdk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-2ltXxZ9cl1HARmVplo014a0Rgwj08Kn9OPgAEwz4Xos="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-qZ7vth9NZiZs4zf4CWH0vbS2yL1c8MLQH0QIHxNZhG4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-lvWFvd7boiNNtFvn8aue48xrxnaOeNBBmQm6d52B2es="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-dJcLK8Pl2wjX2zGIvZFaz9eBm381ssf6L0qjJqjkHdM="; # aarch64-darwin
      };
    };
  };
}
