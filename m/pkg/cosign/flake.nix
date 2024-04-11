{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cosign"; };

    url_template = input: "https://github.com/sigstore/cosign/releases/download/v${input.vendor}/cosign-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cosign
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-l6ah4VZop1/E/3pNxMsvCY+SnL6i8S+qneMdtrQrF9c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ZYCHNR4dT5w5a19Z7lQ3RhwGEo9M6AuomcyqHAtqimI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Dlp3qGEV5MALpCQ9sBq86ssTzAaYHEXlPucfLh24ziU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-/NMQ5k7N3B6qE/6BSsHJ/AL2+erNmlhICrgWDrjKOB4="; # aarch64-darwin
      };
    };
  };
}
