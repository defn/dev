{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/gruntwork-io/cloud-nuke/releases/download/v${input.vendor}/cloud-nuke_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cloud-nuke
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-9Rbz0GUTcixZWF3D+e1uI99J5+0ia3IARW7SYN8kFoI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-SKp2oVuZwYtxEDjrOCI5iULTuQ19fm2dlWwl4yxpnv4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-h9O2jdFlvfzHPGZCOe9pM4ARt+3IrKuZFEWgN2OcTCI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-sHnwQA3cVVEVdFOj4plKBwj/Q5uOM5oXO5tsuJJrQrc="; # aarch64-darwin
      };
    };
  };
}
