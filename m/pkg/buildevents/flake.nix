{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buildevents"; };

    url_template = input: "https://github.com/honeycombio/buildevents/releases/download/v${input.vendor}/buildevents-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildevents
      chmod -R g-s $out/.
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-IDaMwmkmSUuFDOA5Q4p0cQG3GExOy8S09fShq5JCJ7Q="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Yx84iPM5TiBxVxoOW/csC+0qfC6MCGJRPUV/KQYQUeA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-uLGRBFBIYgt1cUbI6PtyxSyLYgQ3UeWXMi8DkWGkK7U="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-mZYf3wdXs72zepnuRi2/Ku2omAaRb1mijMS5ZCjYPN0="; # aarch64-darwin
      };
    };
  };
}
