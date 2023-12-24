{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
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
        sha256 = "sha256-hwz0ktOBqWfTZjb97p2kS1JOpiqtFjZZuNvxan2laYc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-agnSnF4rq1TmjunDD/kpPLp27Qu0jeG7zmmh7R2AR70="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-q/5GHlkVAhoJEDupv2JAkR3W92FCymJ+qu2a/tMWipY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-YyILWQfUfgH1M9OWq4usdIJa9ZZb0OmGJOHY/q9zFPw="; # aarch64-darwin
      };
    };
  };
}
