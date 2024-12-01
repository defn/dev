{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://releases.crossplane.io/stable/v${input.vendor}/bin/${input.os}_${input.arch}/crank";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/crossplane
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-zltAUHUfPDaXhWNw0CZPyonYB54gc3UV+eoFoh5X0m0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Zih3LAEqL/WTOaBNaTgcVlihleVY388X0LMmjLri+kQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-HeJbmjEfw9S5A1ukSD08KgYSLqsbU2zwM6B/HxFYaeQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-HeJbmjEfw9S5A1ukSD08KgYSLqsbU2zwM6B/HxFYaeQ="; # aarch64-darwin
      };
    };
  };
}
