{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-honeymarker"; };

    url_template = input: "https://github.com/honeycombio/honeymarker/releases/download/v${input.vendor}/honeymarker-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/honeymarker
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-qTS2jqpZN0fwpdf0k1DyhW7EDkwma39AZOdW4gnHgT0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HoXY9zZajuX02hNZE7VVJPLhPWeuN+lRBx69AyQRfHo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-VBfBZAA84S5rSZoOQZ1ZLa1LH4N1dgT23r9Tj24FuZ8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-LZ0ovzRfGnO1a7pmu6pK+3cXiwojAZjY0D94CvLOAtg="; # aarch64-darwin
      };
    };
  };
}
