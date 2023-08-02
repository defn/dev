{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/caddyserver/caddy/releases/download/v${input.vendor}/caddy_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 caddy $out/bin/caddy
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-HIo+qxLBGgP7lyKVx9G6FRLtVts8k2ESxCUt0zgzEhQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-+Rce0z64qPTsuw4MIpKotOsP/zR/eBNFA0ckvE5GEuE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "amd64";
        sha256 = "sha256-3DEmCvHbsQoaSeE3A+Wu4PG0gm6prHUlSSEnXvtGUFY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-dDKl4Fkr2PX6XCJq5MytTPaWnTpXNp0gwt34NtjM7f8="; # aarch64-darwin
      };
    };
  };
}
