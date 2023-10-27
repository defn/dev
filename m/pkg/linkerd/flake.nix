{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/linkerd/linkerd2/releases/download/stable-${input.vendor}/linkerd2-cli-stable-${input.vendor}-${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/linkerd
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "-amd64";
        sha256 = "sha256-O64njdzWusGqpIASURo76JHcyEEwjkyrX1b2LcgTHSI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-BzAIIKrgTmhIcPIF68mS+1Im3XjHMJUFJ9ipCOU2LIY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-dzmL+80wojO3gYjlJVS3U+3xl7YLKULNBIbuNP9Giz4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-eB0puneJzbjPy1y9fkhQy+WI0595hDt6yDLKifSPMqc="; # aarch64-darwin
      };
    };
  };
}
