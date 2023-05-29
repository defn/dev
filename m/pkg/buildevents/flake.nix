{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/honeycombio/buildevents/releases/download/v${input.vendor}/buildevents-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildevents
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-oEQftmqh6fKFEynh+IGikyLPNRUNmsyBjkE3NJZoor8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dQh/oHydPj3LvV+jmn74Ab71TkyOuAxguiea3AnAnmE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-vTfbIeLc28s3QayGkh3RAR97El5bFlgUu6MXQhzkFVQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ZzipQ9Jv9//pA/iPsKc8cOiZAN4Cvf0BNzdmYjicLaY="; # aarch64-darwin
      };
    };
  };
}
