{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://download.konghq.com/kuma-binaries-release/kuma-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      ls -ltrhd kuma*/bin/*
      install -m 0755 kuma*/bin/* $out/bin/
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-QOM1KTZ/Zk6+aVyRNHBtBzvqFFesYvnw3MPDMt2Xc0I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-DeVIzWxFsCrA7F7kl6o+/Tx0TIabRt3aFbax04ejFUI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fG04qFoD6DHe8EtL33KjNaXZZd9sRiefM7rlUq/GeOM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-kxwecy3NSSqeiuejBonq3zMQd5GR6tWBUb/Gda6j4jI="; # aarch64-darwin
      };
    };
  };
}
