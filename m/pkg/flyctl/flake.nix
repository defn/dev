{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-flyctl"; };

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-kul2Ek0/Wwv77SDr0DeFEcluKOzm4JKAFpLX49AAmzY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-SMeqiCGY6qh91OuNTDNCs7i+gvX+FqL/GIs28GhQw3Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-U6aUbpp12lbGGHRFjq68UZJDAqcmhVPRwEV/FYYgtdg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-jdou3raOPARpQDMBo98BIygZHtU4QBQ9Uyp8hZz8aZQ="; # aarch64-darwin
      };
    };
  };
}
