{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/caddyserver/caddy/releases/download/v${input.vendor}/caddy_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 caddy $out/bin/caddy
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Rj8+eHk/VgZJ0xFErA+6LPuWwCZrJkQwV8xIKYMn5qk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dduc5eakGhAJKf+fWEl8a3gEAm2Gyfq5qrrdQ+eccxs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "amd64";
        sha256 = "sha256-VjpjmHgY+ENdFzemR5uWCR3rh8uH/ry75ULXwW8SKHU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-j9rItGXUaJ2sAtWUMt8guoL6B+RgFgh2NDGL/EESegg="; # aarch64-darwin
      };
    };
  };
}
