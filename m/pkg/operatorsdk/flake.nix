{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/operator-framework/operator-sdk/releases/download/v${input.vendor}/operator-sdk_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/operator-sdk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-kNiOgQe9h8evGkn2ShDf33K/EQZDhCUjwe8SOvIh7io="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dY4Ga4eeMHVpuvDVPeTzpkbFRKJg99F+ZBjzSVo8ehk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Iqrx/6SYscWJmVter8YVKD1HdJpQePI4c0q7lWrgtLw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-SRhwR3zTstEiDDRNHW6zRotMhcmT+rLWWwriHwFLpCs="; # aarch64-darwin
      };
    };
  };
}
