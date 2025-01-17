{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-eyHiQ8DJ/3J5Md55GEfqWzGqCr+FEcSAo2Zrd5Q9Z1I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-2vMX44fLhoyVn5CD1Bd9TA4w51ghFq7mcIKM3Pz1Paw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-McMkLkxUUzOFHcG+vapIS9smYieFir3NdrGUF+DWoNw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-/f9Lq4nq0FcFm4wG7onYcTk/ssSakBYfQTDpEdsNSgY="; # aarch64-darwin
      };
    };
  };
}
