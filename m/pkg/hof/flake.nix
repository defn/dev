{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/hofstadter-io/hof/releases/download/v${input.vendor}/hof_v${input.vendor}_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/hof
    '';

    downloads = {
      options = pkg: { dontUnpack = true; };

      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-65aBc4pSr8h4Glx2tl3uF8jDa8x3qn969M7gdwY2/A0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-0xfjoUCDq2S7yU54r7//hT/U+IF5h0AEodTVPYrmLRU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-bCbQfCXfVdcFH6ausGT5Cip3YrE35/l7PHfpvGEyJZE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-/6RIFjK/YdOIxWAF4xQQM/eMJt3v3x9HnE/uShlRjQw="; # aarch64-darwin
      };
    };
  };
}
