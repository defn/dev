{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-ZtQfpY49YBUh6gQ1A5tvTlRkIvb51lt8OO5DYgLysrY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-RHyJZCxPK1EQBaIZyGZbhsyPlC0UF1oCVpUJAuzOfKw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-0ubholgrtpeNch5/dT+u8sxn/19PIz0ljAp6w8xCxAA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-BDjIa+fUZJsGHEUSgUXMUqd7qbrIvF/kFjlZvFKNS70="; # aarch64-darwin
      };
    };
  };
}
