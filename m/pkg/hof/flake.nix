{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/hofstadter-io/hof/releases/download/v${input.vendor}/hof_v${input.vendor}_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/hof
    '';

    downloads = {
      options = pkg: { dontUnpack = true; };

      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-DC++uhL8bx4L4YUbWXJYW8mUqYFM4AgKaygco00mx+4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-zOi2ChMEb7epe7DY+WDnhKmWUF9ImmB0NP1YEWeIhbc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-jYtTGgS6uJIRqaCtRje4iWO3SvXSblDmHavs/6Q/uGI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-xA86I0dNMOY4l1Qie/PLxdSTfh5pagGlAwvxD3U335E="; # aarch64-darwin
      };
    };
  };
}
