{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-just"; };

    url_template = input: "https://github.com/casey/just/releases/download/${input.vendor}/just-${input.vendor}-${input.arch}-${input.os}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "unknown-linux-musl";
        arch = "x86_64";
        sha256 = "sha256-c5VQmtjAtIE8H12MM5BuQZdxsOnqZ4WJIrLPLmN5zLw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "unknown-linux-musl";
        arch = "aarch64";
        sha256 = "sha256-9FhJ7r4RFCOPvrU2Pb16vOOLclI84LYjLLiplgcPQgE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "apple-darwin";
        arch = "x86_64";
        sha256 = "sha256-doCI2ta5vifkt8Zbibxp5LsvOLfdvI9+bKrpHYPFr/o="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "apple-darwin";
        arch = "aarch64";
        sha256 = "sha256-jEJpWVV0PYroxdy8oaKo6A3KHdfdvxNT6d5jUL9tcW8="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 just $out/bin/just
    '';
  };
}
