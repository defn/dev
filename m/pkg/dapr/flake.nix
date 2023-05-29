{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/dapr/cli/releases/download/v${input.vendor}/dapr_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dapr $out/bin/dapr
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-SAY7dRoI9OMRxWxJMM/sSLwlvmLOthv2aRMAoLlyn2E="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-nutqZgL3usNJTbugR+23fCbSkc7nIgjz0nmCyPQYFMc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-dGuCPPldKYQOsF+dx6e0jQvUv0x2T2Jyq7SUqyq5FV0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-EwCRxxNfPIxyx8uNAv72tA+RtEg+sHGG7FYYguC91QI="; # aarch64-darwin
      };
    };
  };
}
