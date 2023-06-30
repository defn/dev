{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-bOggKCv7zR6MkUYW20URHhKEkf67bTj6ImfaaXsIZds="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-+IMjb4QlOjT6CBeuZFqC8OrXSZ6e2ZlsoZ+xWref7fM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-l4dpKySdFY3Gi2DDZ7RGqRN3p2KlGK/aB96JZGVbHxA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-QoF+ICyZx2mNetG5TpJYnRED7pOHMZXoCx8XWtwH4vs="; # aarch64-darwin
      };
    };
  };
}
