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
        sha256 = "sha256-TYQaAYq/7kI2LczwbkeyTR6HTrcR2pBthDWnS7EUYrA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-5rp6WgPqyB05+7Jp9vzukiGL4uduBSqYQfJw6wpxyfc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-OW2EGWmWEoPThclRRBLDSKQ93USv55MEau/NksvRerA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-fbGifSA+G4WrD4HtleO+M4b7pQiZ+y4U0HNcrcMqlNQ="; # aarch64-darwin
      };
    };
  };
}
