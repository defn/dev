{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-GIwH84k15TIFxYCMfosZX/FTb1yv0BIM2Jr3poeUVlU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-5wvut9PGdCmBzf6mnVfVQrBkCZsITA+hGHQoFMUbzuI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-ts+Ct6z4iDgcN26QI+C+2hGoxgjw8GdUeUizvqJUEsk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-M/46HsLFAKRolyUvDDwRlqdStMi/+WsVcmf+Qr/zpvA="; # aarch64-darwin
      };
    };
  };
}
