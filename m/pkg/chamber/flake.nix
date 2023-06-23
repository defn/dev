{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/segmentio/chamber/releases/download/v${input.vendor}/chamber-v${input.vendor}-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/chamber
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-QRj55xf/pXzwQSjHrVQke52Mg+nSECxGbSkD5JoEUuE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-QRj55xf/pXzwQSjHrVQke52Mg+nSECxGbSkD5JoEUuE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-tX2jAuZxTC38Owy9wBGvzWnS1RfsCEokgNP9UGpO7sQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-tX2jAuZxTC38Owy9wBGvzWnS1RfsCEokgNP9UGpO7sQ="; # aarch64-darwin
      };
    };
  };
}
