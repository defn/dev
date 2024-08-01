{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-just"; };

    url_template = input: "https://github.com/casey/just/releases/download/${input.vendor}/just-${input.vendor}-${input.arch}-${input.os}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "unknown-linux-musl";
        arch = "x86_64";
        sha256 = "sha256-fmSA7hwbHJBvfxkzzBobnygYEjQfmXt43NFmQw9epQA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "unknown-linux-musl";
        arch = "aarch64";
        sha256 = "sha256-Ii6sKHaa3GXqLP8DfQUxvvEt3ajS+izAa1ZMliq2KHU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "apple-darwin";
        arch = "x86_64";
        sha256 = "sha256-akdQlEe/zlGGBTL+0DhtcZTc0bYyKTAF5/AYi3mmzYI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "apple-darwin";
        arch = "aarch64";
        sha256 = "sha256-N525yvaXIxtgsEqyzB+PScHhZZcCjL2YwUO3IP0OSok="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 just $out/bin/just
    '';
  };
}
