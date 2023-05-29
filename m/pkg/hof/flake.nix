{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/hofstadter-io/hof/releases/download/v${input.vendor}/hof_v${input.vendor}_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/hof
    '';

    downloads = {
      options = pkg: { dontUnpack = true; };

      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-ISuqpf06DNkqYYerFgzrKJygtSHMHO6hLNFgHyHkyNg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-3+G4hoYLVsDwE/OVKepOcpvjbDxAqk6Mm6HlYt0zB90="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-p8pRWgB+TWwBDaGdc5LWmnkK8QsV5vwk6tBh8Z8Jucw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-URzqcdXBcfdemjkG5Hzl67DTxfgxlZKtAnBF6sKin+s="; # aarch64-darwin
      };
    };
  };
}
