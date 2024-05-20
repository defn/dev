{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://packages.konghq.com/public/kuma-binaries-release/raw/names/kuma-${input.os}-${input.arch}/versions/${input.vendor}/kuma-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      ls -ltrhd kuma*/bin/*
      install -m 0755 kuma*/bin/* $out/bin/
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-2Bxp7TYLcZNKXKuUUbQgcPlLeUMo5AH+u3XmZv+wH6w="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-jYgfV6g5lPECIqRkpmosqOdJbdErEFcxIOjHdOL6fkY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-E4XRWDGdyGAjUJHwMGtWTVnUE0bd46ajg9uXLtCKq4Q="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-u4R8UV5Ih+P3EG/U133TUvLjXgi1IJur6QaBvYp2gBs="; # aarch64-darwin
      };
    };
  };
}
