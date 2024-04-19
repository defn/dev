{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-coder"; };

    extend = pkg: {
      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/coder";
      };
    };

    url_template = input:
      if input.os == "linux" then
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.tar.gz"
      else
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin $out/lib
      cp coder $out/bin/coder
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-6VS21x2egWBV6eJqRCBGG7mEGPIDFtY9GN6Ry4ilC70="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-2QAahqcM2gi3lT+18q2Nm9GNqVsqzX3RajBsTn+KB1c="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-UBUGjA+jUkT6p9714l8IvDDI/qhWNctVFOvcA2S5kQU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-uEH7Y7c9BcU/Q/jwx/inFMvUrgm2dUruID+FJL+rA6Y="; # aarch64-darwin
      };
    };
  };
}
