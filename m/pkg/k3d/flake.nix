{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-k3d"; };

    url_template = input: "https://github.com/k3d-io/k3d/releases/download/v${input.vendor}/k3d-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/k3d
    '';

    downloads = {
      options = pkg: { dontUnpack = true; };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-GsHaNlI2c2qN+MMhB7VKyiCDhKsdmgZ3FEPIWtaYpes="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-vFgODKkHFWrNSV1Cl17RaHqzqawDkq85Ga/GKoqLZnA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-y0tl6hX2I4TCpb+Wka9lTLxdrsfwgDdUucRoPDs25sA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-NMWt7N03y6RZYwgHw0MpZ5GR0ZjQ7AqcUhJxik+xyfA="; # aarch64-darwin
      };
    };
  };
}
