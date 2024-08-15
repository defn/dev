{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-goreleaser"; };

    url_template = input: "https://github.com/goreleaser/goreleaser/releases/download/v${input.vendor}/goreleaser_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 goreleaser $out/bin/goreleaser
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-G/iQn6VWWZ8pBFsLAV7nX2rseJ6S8XNDyxNuRUmdqYo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-2aVz2ckjbzaiy1ssYsdSe0wWwYVNTilCoOQlj5U13ek="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-Uxa09lchT0uVR36jZgUjw++7eKe+pdn0PFWXLwhzV0E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-W0LduIxWRPeDWUm0XomPSXnm0oq62QnYpYRZmotZ5YI="; # aarch64-darwin
      };
    };
  };
}
