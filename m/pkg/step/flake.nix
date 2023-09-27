{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/smallstep/cli/releases/download/v${input.vendor}/step_${input.os}_${input.vendor}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/step $out/bin/step
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Tu8xjlFcheJTqcn0vi5+8lYIoirKV1q/LX+iR6CqFos="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-I/4a2LKz0GdjvT8YZp5bgGIp4qr2yphguEXv/Va6b6M="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-0MX3PiaVQ1y+khnypjlqdAnvGG6qJhnG3cOzan255vU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-+VZA23hHZY+nfCzagVP/bblIygzaek/sRnb6o2tJhtw="; # aarch64-darwin
      };
    };
  };
}
