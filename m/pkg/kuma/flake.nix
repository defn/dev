{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
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
        sha256 = "sha256-e9XernbUlpezQ3/rjDeJCq9weSIZoVXX7H6YPTpVMpo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-y0sM1A9EexOSepxclKHMltv69mLxDaJ+4N01ECzw1WY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-b5XbbzrzyKX/AsZsHQjhxm5fDpOZDrmRZMHFcEKY3Q8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Am7cgkyafji+kN/AqRQRh/se5E8u1Ahbs20a7TnAd5o="; # aarch64-darwin
      };
    };
  };
}
