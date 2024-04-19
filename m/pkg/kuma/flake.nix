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
        sha256 = "sha256-q+b+rzAFX1bH77uXMZLja2LweOl91DujfFmiQF05u2Q="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-3eZF/CoqmN4insUyQv4j+h3UdZRu0m923z+9rnDWsZ0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NqfKB83Vsm1SZyHhPihI4UGTtHVIhBfdoxgJ4RzDpaM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-NrCHZwlfOjbeEa7QCISPL1ZhJ5VEtIyNc6oYWLd7eow="; # aarch64-darwin
      };
    };
  };
}
