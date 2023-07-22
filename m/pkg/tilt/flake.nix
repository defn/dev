{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-MhVt/qcjmWJa77hxebxOGd6HCeu+QqDUzNoYgO70hNE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-qVBFaoD4XUbVOGCTBdaniv9zEeE5C6Jl1mI7/VivlT0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-UrWCnqoJ0oWXXmfTbk+aBf/Kd9gcQrkqop8S5VopSEs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-Q/qVQc81r6dUQSrRAfnpupJh59MhI5iTBPXiDu1qRA0="; # aarch64-darwin
      };
    };
  };
}
