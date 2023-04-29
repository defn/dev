{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
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
        sha256 = "sha256-95Zw78ZNBSfguRWicq6oJitIZK2SmOjRzzm3sIUXYHw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-euPUv2/xIRct2Um9TSU0LgOgt/EM+OjM3I+YpmS3l5Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-Spqa+AJjDXVH3715cnxGLses1JeLkbkilXQ41K7Jmsk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-i10ChbEcFKvRf6jXYEnlupDod2eEzFeqCvdwUu4zXpk="; # aarch64-darwin
      };
    };
  };
}
