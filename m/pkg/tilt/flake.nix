{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-tilt"; };

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-sUzJ0zsYyL32m1Q5FGlrJS5VPJNh9l0u0M3tMCaYcI0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Sc4ZmBdhthAs9f48sV1s/fa1aqK+ehF4RXlVx0dr8h8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-MOATOIYBScOjeAEG8AsmG++nxxBL+15ORNsPdxN1NNE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-27FxZDKnmjG5xfGELPzgLyq7+bz6eJ2a+8QdFV6TCFU="; # aarch64-darwin
      };
    };
  };
}
