{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cue"; };

    url_template = input: "https://github.com/cue-lang/cue/releases/download/v${input.vendor}/cue_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cue $out/bin/cue
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-D1GywgCytbkj9FnKf5pIzoBN00pgRKXp3/E56bk/TNM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-d9knj/oj/Dbym46lbYRoYlNlqOO+CpDX7v7TjAWPkEw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-6zcp+6sm0LFqJF6koCYBNGtiqytiJ9XSHplp9iRzlFc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-y069gD5mYCcfTKlfTqJELUyCxEv3cZ79zb5ym2Tf0HU="; # aarch64-darwin
      };
    };
  };
}
