{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/bazel-watcher/releases/download/v${input.vendor}/ibazel_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/ibazel
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-/xREkm3Ydm/ZPNqd+7o6zIavzM/VEzS3gJqC16Sd8hs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-WL/lVZOv7s4Hq5kX7QfsESfvZqAHJ05H14wfixtdB68="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-h3Va16G9/epQ1SJ7rbh614dfuR9PHTjpzSd2HNo3cds="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-qMdtfDpHEyGIiYN694qtrXDrYFtlA03QHV/Zod5H7qY="; # aarch64-darwin
      };
    };
  };
}
