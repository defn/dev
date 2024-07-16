{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/nabeken/go-github-apps/releases/download/v${input.vendor}/go-github-apps_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 go-github-apps $out/bin/go-github-apps
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-EToHn277c4+pJVtnWwiu6l83ubujNspMXsL++8Dkmak="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-TppPNR+2Ei/Dc35NU8yWUyGKicZgQILJluVvuO1pmPM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fwHV887re+pne0yJupHveJj/UY1wE0/FySGecG+5vhw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-c6W5cR4EBXULcbBT4jRfCJs8ZZNiUSEX9QQClXDtRIU="; # aarch64-darwin
      };
    };
  };
}
