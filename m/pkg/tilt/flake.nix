{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-tilt"; };

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-/bYqtfngzyy2l/ix6R8pCe5hqxSJn2ssGhRMDXKdmaM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-e52FlDngY6n7JwHB3uQeNFVZCvtDbtwsmn/GM7udN0o="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-pjn/Mwu6WwMflv2QdKsHZyCupbgg6R9BX6ekG2qZ77s="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-tLRgsC604mG1EqfHk+g4G+8aWtuGTvRtP8rj9qMPyrM="; # aarch64-darwin
      };
    };
  };
}
