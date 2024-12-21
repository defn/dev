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
        sha256 = "sha256-Ouu6D2p7o3IDrS5lA3v2dDMOuroUMImj4iNtBkmUkYs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-6/rdAtZyAiJaDtgHk/IDs95JqgIH3o4X5thiRU6+hDQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-/YPF1/DkKsyrkZv7Buh15yZ/fNKPVudrf8jQy2TaYPg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-dUlbDIWaxxqev/Zy/i3MaaGYFHvPdlab7E0hWO4/cCo="; # aarch64-darwin
      };
    };
  };
}
