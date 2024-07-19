{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-hubble"; };

    url_template = input: "https://github.com/cilium/hubble/releases/download/v${input.vendor}/hubble-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 hubble $out/bin/hubble
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-pVw2pzzAhQjlNuIxgiuibBXwsK0pPj7g5BATlgLK7zA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-qSpwlcujjEYMohVgveqih9fF7eEoaJP4zfzQNQgtI4Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-8m/E032uKigEhT5xjd5EmgaCFjvespPwSWntcVPOw1c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-17AJJ+z/XybhOcA6o0YwtdYj+w0BUaNCWKG7FqyQz98="; # aarch64-darwin
      };
    };
  };
}
