{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/coredns/coredns/releases/download/v${input.vendor}/coredns_${input.vendor}_${input.os}_${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 coredns $out/bin/coredns
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-mMtg4zWEObuz4/e+kW/hDFGx7ZR1j1OusrTAYVZhL/Y="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-MasBAAfu9BlVHNee5x6wPR/STunVl9LuTKQHccTgtzw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-VZm7s39kVrzm69ojZhaZnGtytgySbKlxcrQIQe6Vu5k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-VZm7s39kVrzm69ojZhaZnGtytgySbKlxcrQIQe6Vu5k="; # aarch64-darwin
      };
    };
  };
}
