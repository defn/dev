{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
        sha256 = "sha256-UEu7lLVdRgUVe3i/d0fMp3iIiRD4xlcp/mnLlMPTf1s="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-V9r1hwcxR0AkIfXYvwaQGPc8tmotpbQ5O3Qu9Z7hUTk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-T/wdSHB4qu5wF0bi4SL+5s1rpq3Cmv3MMmSW6Y5pS7A="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VkUF+mPjfPiVh4hBL+olw8kOoBcm/1nWXV6n7yMt6i8="; # aarch64-darwin
      };
    };
  };
}
