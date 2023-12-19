{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/buildtools/releases/download/v${input.vendor}/buildifier-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildifier
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-vmPbEomfSGALrZQFESOx/XtSUedmG5FoWCzlI5YTLpI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-GFQPwQ+GGQ+HSF64aWPmA+QfoCL4ii0bDPUv8lK14d0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-7rR7LeJ/YO/lSTSLGD+sJOroDxR56LBsrAeZxIbfW+0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-+ge6DSAWWRfKTMdgn5sZqKQ5KJgUi3ur32uyp92WPwU="; # aarch64-darwin
      };
    };
  };
}
