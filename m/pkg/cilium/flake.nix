{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/cilium/cilium-cli/releases/download/v${input.vendor}/cilium-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cilium $out/bin/cilium
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-5tOy0pcSmxD1aQVYqF6X0q9AesMNhXWP933qaGucEwM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-fPE+EBYvT/YRThfIU3e5btkfGH4xMeDGw12Pahgd4H0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hAfqSuCX/YaPuGpv0Rp8i299AXA6G4G200uQHHAH4so="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-gGq2v7AD0pCXWrZ75i51yB8Mrq54ikIELja6ckZ8sgw="; # aarch64-darwin
      };
    };
  };
}
