{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/vhs/releases/download/v${input.vendor}/vhs_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 vhs $out/bin/vhs
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-VCNMc7onyoMFzEVzvhirY2tWW4g9GVIdBUNLARrrCtw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-rnWPbALBhmo6MHDR1yHah3SzByztDIiZXvgKqe4nquQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-GGlJ6Is0BqQowbv0EGVju/NOE8Cv27R1pJuYenZXoRg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-aILAqGeYyA+Q+1TzQ6pWXNDXwdQPG4IuHesfONUnhJo="; # aarch64-darwin
      };
    };
  };
}
