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
        sha256 = "sha256-boZPCMUT6pvFSrPt7q400MYTd3CwLeJTGX9eJnVzhu8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-DauLu+UUrF+2yk8Gs0qT2Z6Z1kg+nqqUbDbNmAwmXzQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-L7V/6W7a+O7fpUgJIhKxBHcE5AdiB5BeUY9do889gmk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-L7V/6W7a+O7fpUgJIhKxBHcE5AdiB5BeUY9do889gmk="; # aarch64-darwin
      };
    };
  };
}
