{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/buildkite/agent/releases/download/v${input.vendor}/buildkite-agent-${input.os}-${input.arch}-${input.vendor}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buildkite-agent $out/bin/buildkite-agent
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-FqPCQYZ5oSVAzDDisGsLB1MqIposCdVyCqA7eBl7L2w="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-VKyJPvVI396MetorzZFPGGIxrZAc6DDXpErYGQb9ih8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-dhIQrJi406Vjfdd6X7YZyX0GpoVi1brGQxjnvioAmIM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-dhIQrJi406Vjfdd6X7YZyX0GpoVi1brGQxjnvioAmIM="; # aarch64-darwin
      };
    };
  };
}
