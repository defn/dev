{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/honeycombio/honeymarker/releases/download/v${input.vendor}/honeymarker-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/honeymarker
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-9jYH/JvUCX7VOuS2OtdvUJ0vUIo4NFGtcKuwc6rujg8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-+pjtkAojsD18/YTbbz5y9NAXG5v4/5xjsDm+2HKMhuQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NmSXu7WuPZzm93SNsKALgvXAIDNfvSbvG659zJH4sw4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-EC3OQ4OCa605WUOBIiPGZq0h0Ai5g3ny5NLE6qu7FPQ="; # aarch64-darwin
      };
    };
  };
}
