{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://download.konghq.com/kuma-binaries-release/kuma-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      ls -ltrhd kuma*/bin/*
      install -m 0755 kuma*/bin/* $out/bin/
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-FmTF98tgRCfMG1T24r8rg0+9qNvcQCQ38wPbwnTsaHM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HuZypyEnQy4rJkjVsHT+Gyic2rWQfUzNNHtVMeFEQts="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-spAmrG9sG8TNZxvCuHDnkIRIzKVcdtg/UaoZP1YApx8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-GUox1sV97l+0Gtj2PSw77xHTBMbAweCk9IRrGkyBBQI="; # aarch64-darwin
      };
    };
  };
}
