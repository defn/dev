{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/terraform-docs/terraform-docs/releases/download/v${input.vendor}/terraform-docs-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 terraform-docs $out/bin/terraform-docs
    '';

    downloads = {
      options = pkg: { };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-MowWzWVSs7XEaGuNlFouLhjSuBRba2YSnNVJGEABAYI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ggjBnH3AFmDmyu/jLjOsAuDgP9wuKt4Ls3q7Y0kVPSU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-9IQi4uPEowhSmSF32xfLN7GIEKPoOSQBumnodci7EJA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-p/DCQ3Qksg2JMV0qewWB59Mv3lOdCwbElAOUnfHuYuo="; # aarch64-darwin
      };
    };
  };
}
