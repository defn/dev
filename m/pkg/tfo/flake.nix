{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/isaaguilar/terraform-operator-cli/releases/download/v${input.vendor}/tfo-v${input.vendor}-${input.os}-${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tfo $out/bin/tfo
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-5D82mojoUkRuhMgzbt0gqfRSAGcmkzRPTmN9dnex56I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-oQY6Ez8zsTxpn6vczYr+cYVmphlLOmc2hBnWH3s6fDA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-4oWrrJ0wd1t044r13zzFPpChJmEisZaXg6mKDtGEpTA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-4oWrrJ0wd1t044r13zzFPpChJmEisZaXg6mKDtGEpTA="; # aarch64-darwin
      };
    };
  };
}
