{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-KMv9Z4/XqDLKO4rUtlBDTC4cXQl2DZWad/QbpLCUKTo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-cM/TPYWnxhCOPdr4s++Gu9ovDrqy/dKGlDakM441z+o="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-/nP2bqlH9rpllHhGmpIW1ypvyjo8UAnX7lE15k9lP4Y="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-ypF0u4EsCV4ASdAuE2I5XAzJk+qgoWHUzWL/HpixiQs="; # aarch64-darwin
      };
    };
  };
}
