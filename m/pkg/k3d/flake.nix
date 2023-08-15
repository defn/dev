{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
        sha256 = "sha256-vQ+sRP1cbmlisU0lmi4TIp7/tmJeTUM6qtb/du0vB7k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-JFbyt9uJKuj7M5KVQ8Cp1nJ1W49XsTPqMsg7Oq4vdtU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-5C5hQt2DyX7da6kgXydluWNsu4Vp/N2MYesTJ+6bWGk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-pxNjd1hgiZNOp+9LG3bKRyEoO7zNUTZwxgoDcvwsYLM="; # aarch64-darwin
      };
    };
  };
}
