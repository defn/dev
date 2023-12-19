{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-t+2BqJUqVSChppeMPPaLH9VV2SikRMY9S4Jq5vu22f8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-+dvR/xzSbYUcisaV3svEzuqX8qh8z6Fv+AWrX0mum4E="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-ISE4lX5AQV8OtTyMdzOIZEimm8NDkZf8qPKB+EyjeeA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-6OTrU1nIOT+sw5B+esQzvTpDwNSzAzGs2hFAVPsQ/r4="; # aarch64-darwin
      };
    };
  };
}
