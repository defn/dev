{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/coredns/coredns/releases/download/v${input.vendor}/coredns_${input.vendor}_${input.os}_${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 coredns $out/bin/coredns
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-0zhV57PrrClfeMWwu9ZSjrfLaFk1n/lmDvisnebUcVU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-p3tviGh9KMTiXIxhsnlw7CR1fjkke/6YC75SHziUWq8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-dYaBi93Tjmf6mh3O0LZ+/Xbhej9ouzhQAtUBgTfY7mA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-dYaBi93Tjmf6mh3O0LZ+/Xbhej9ouzhQAtUBgTfY7mA="; # aarch64-darwin
      };
    };
  };
}
