{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-stern"; };

    url_template = input: "https://github.com/stern/stern/releases/download/v${input.vendor}/stern_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 stern $out/bin/stern
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-RzMmiw5/6khCbFlNGGvoy824Y4WOCJEEUevjscgob0Q="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ELfOJpmWVHsItSQibZx2eJhbUlIyU55ulD6+hHVSFhU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-TsESgLIc3EYTTysQNJiR+lo3Z43qnBmaEzQD2rPcpuk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-GNpHQGYu8LYZLYidFb703NTyEgNvyN4wauwdCGpZhjg="; # aarch64-darwin
      };
    };
  };
}
