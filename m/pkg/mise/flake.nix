{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-p/6v6Ias0KKXO3Nx0gffa0X2uoBt20wTSEB0K4OPH3w="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-vBjuY1EoZebYwMLz45m3w0pJQ5kl/yxglrW76sd1Wb0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-YNvuZP/1NIzc/xwu6x1I8PbRALbKD1uyiP9BRZr3Yg4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-zxU/y6LdQeimy0D9buj0/V/Djf9HD699CSyMyS/6Hm4="; # aarch64-darwin
      };
    };
  };
}
