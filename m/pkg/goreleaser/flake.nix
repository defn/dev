{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/goreleaser/goreleaser/releases/download/v${input.vendor}/goreleaser_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 goreleaser $out/bin/goreleaser
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-gZKZdj50tUZDvMc4c8mUJGmGhItynRkJEGlp4SRBTeE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-DaqnYfi7aEpopFEfkRaQl7NMWc677C/PbN98TZcPkt4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-ZCstWkvQsZBVcIeSEz1JIPZHsh6qOpOWLpsNkSDBHB8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-PF98QcKvexLge6LjsWEoN/H+1R/TSVuI1qDTGSbeu44="; # aarch64-darwin
      };
    };
  };
}
