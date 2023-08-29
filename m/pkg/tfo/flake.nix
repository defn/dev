{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/isaaguilar/terraform-operator-cli/releases/download/v${input.vendor}/tfo-v${input.vendor}-${input.os}-${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tfo $out/bin/tfo
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-xMNwco2eU76vV708uvMmKQIGAMl2YhpQLd0GS0jEODM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-4tItY6Kjts8f7EQtlWluTQkbeo3nr81bTkgQW3yRW7g="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-3qNTUYEAd0GhFEHNOaRPN7/sOzhHx+iwsNIbixfOZgc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-3qNTUYEAd0GhFEHNOaRPN7/sOzhHx+iwsNIbixfOZgc="; # aarch64-darwin
      };
    };
  };
}
