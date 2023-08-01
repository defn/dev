{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/bazel-watcher/releases/download/v${input.vendor}/ibazel_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/ibazel
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-uziNcep7xtdxFWI45KLAe8m18KqfKf/m07VuH8mT5LY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Y2A9ssFL4x+yMUiUpCKiofAxRIueeHeeIKk7iRL2bms="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-UlDzGr2q8cIAwbZ/EP91rCY/lKI0sbP7PeyHUJUUZFI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-yZZf9SgfknAuO8XI1iPNoIVTuanZA9V0NdIJ99SF2d0="; # aarch64-darwin
      };
    };
  };
}
