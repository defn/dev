{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buf"; };

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-OXFs/gGF3zy6IfZuxzliD/todsSLLaQzioxowpDJsRY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-5xiIMwOdTnc23lF+umFBuTBvS2CwCXQ5Lax844YnMh4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-CNHHKyOuf0Mk4L3QpwBjgjVybMMS/IMgzVl71hb2k1g="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-EIyabxAWfh/LdTqfNT/GWNJaMguA4e6tjtMVlPuuXeE="; # aarch64-darwin
      };
    };
  };
}
