{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
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
        sha256 = "sha256-rX5+yaLKLxEmQldgphAuZBZ7FTvIFWbgDRQ44V4IRBg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ULtq3RnJNLtukWkBOESKfzEnBZ/jAfSugqpNkd2ftSg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-nejGuCoZ7OuEhhi2wUXVK9zLVjpDZIQeV63czMFI/d0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-+vNiLEw0SyzRrpbaXsIwo5L9s5YXrAFp5fLOuI51VEI="; # aarch64-darwin
      };
    };
  };
}
