{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input:
      if input.os == "darwin" then
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-apple-${input.os}.tar.gz"
      else
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-unknown-${input.os}-musl.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 zellij $out/bin/zellij
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-QpF7NezGu9HcAPUL3YkEI9hsStZ6zjxAZsSoQqRYHEY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-PyC4FVYA/scA4Z3CeSWsQ6wgLbLbrNg4YPrzySqxgA0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-9mjiwTwmbVUNT2AAGNlz8mF/uWUJDB7FO9WvU3GM5jA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "aarch64";
        sha256 = "sha256-/LugC9k0xbHdfQmKqF5l16JNT0Aj79xXZ+j/BajB1lc="; # aarch64-darwin
      };
    };
  };
}
