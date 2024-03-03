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
        sha256 = "sha256-0GjExiDXn1V2z9rn4cKYmr0d08sPR1ssxUYd1+eGqOQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-Iu3aylMbUBF8Z3ZlJQ02/6KJSrt5n4dX6/csL0QkaMQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-gvVzfaQ4WCAv6MgX6llFigjl3BoRlzhOn7Z9X9Hnvds="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-YMYBiiKUD07fhyF0sDFHhXWCgDMNiAnj73IIe64ah3s="; # aarch64-darwin
      };
    };
  };
}
