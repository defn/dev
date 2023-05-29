{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
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
        sha256 = "sha256-Yet4qUyb7A11jYiNcHwnObAbkn3isV416ZtATKzkIgo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-SEPsbYV+usAV5dd+x8LBNzCgU36JC8sOEZPqS7XmsRA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "amd64";
        sha256 = "sha256-ffrm40HwsT7qNs3ncaLUGQdOGzjcY3GZJS60oLaTzo4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-N8xbVqnWe3CvdtzEXrsN8RaonUQZtSVU+Q9WtDsYWSc="; # aarch64-darwin
      };
    };
  };
}
