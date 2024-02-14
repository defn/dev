{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://releases.crossplane.io/stable/v${input.vendor}/bin/${input.os}_${input.arch}/crank";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/crossplane
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-xO5G4ZEpI/6BIs2xjdhhNg/ZbYxRFOAces+5TtwXZsc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ZR+eQxT5c8Hn+Ig29K/WWXH5GsAqY9Koo1mxyFqzp4g="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-2LDmjIm7PHKL3X+OAB5haDJt2rZFW572lTZh9iYJKKg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-2LDmjIm7PHKL3X+OAB5haDJt2rZFW572lTZh9iYJKKg="; # aarch64-darwin
      };
    };
  };
}
