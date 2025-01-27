{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-28VjoldE7zUbdZ/YjD9NZ8ZMnwOo1+zSL8XWPJzDDhg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-uq7Vq1ZMAoRVwmI738cyMDwBk+JhUiFUBRKnt+06cro="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-qOo+9XqSY+Sr74zdMjuKkStwc7oStV56kvqBIDvaf5M="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-1V8LUg4qZRVn+iNY2yEq6APGzXc4AUs1upCH04NhO7A="; # aarch64-darwin
      };
    };
  };
}
