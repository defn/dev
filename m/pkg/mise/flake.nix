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
        sha256 = "sha256-PMp2oER8t8+/6HCSEr1pMf52Cw0WrjrKL1Vbzh14Qjo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Sf3U0I27BXN6icfMHjil483NG1Shs8m6/56Fi8Pve08="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-0J/L+hNuzBZJ/ZTp9i/JhIEeM2KNRJ6YHNv57081iNw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-pAvcfW5VPuZbifhKq/H1mfAlpGpz2T0AFJMy5CdPJEI="; # aarch64-darwin
      };
    };
  };
}
