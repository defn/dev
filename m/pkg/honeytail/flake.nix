{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-honeytail"; };

    url_template = input: "https://github.com/honeycombio/honeytail/releases/download/v${input.vendor}/honeytail-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/honeytail
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ycx90aorEq/rMLCJBhhw80B9LfARnnwoB/7GSLYD4tU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HdNyJ3iFSMTtRFklVOPJDjdMTXlsRE3enzctuGGLx/o="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-mj2g9I/iGx5hCsa2MTDfuBGKmg7BarrhM1DtugLYXk0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VRD1mhxOXl9YSUa/PLNTHM3bOQ5m/swgqm6MIvPThTY="; # aarch64-darwin
      };
    };
  };
}
