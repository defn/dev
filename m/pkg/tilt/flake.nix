{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-0lNElY857aM09a4Nw7srE73OS4UQPPBa6xINAE3hhuY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-z9fp6QuUMn4aCcW8vbUarwO+eomq+8wgjGQYhwwluYA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-Mwq5BymuFhsZwjWWF8DgjLnLXt6iA2HL3IS2484w1Ko="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-TGzJtNi3pvIkyzpzjiLr47jlocXMubHubmVE8SmeN5U="; # aarch64-darwin
      };
    };
  };
}
