{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-goreleaser"; };

    url_template = input: "https://github.com/goreleaser/goreleaser/releases/download/v${input.vendor}/goreleaser_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 goreleaser $out/bin/goreleaser
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-SPC+agAeiPBurrxwEpNdbGMGE3oA3V4MA0xJubuEkgs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-pl4Pk86PUG9IOC70TY0u50UG7gCgKudNbhHa4UnZVgo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-V6Gasj1n9jzBhwyrH8t9pUoBAwvYv5BtyZ/b4L5owp8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-sQGmraKN8xIo9zfcJnsQJUdHDZF6CT+1AJDu7xCsv2M="; # aarch64-darwin
      };
    };
  };
}
