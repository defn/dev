{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
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
        sha256 = "sha256-bggDj0WH1RWFYHZ0atOmnmc3bt3TjYZX9Emq05O5XNg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-/vjDg0Gchs6rsLv/07ytK/kiNTf7qfhIIYSA+HOpbo0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-1W3dkAQEOiPrZi9aQJkP3prIozlFM3hVOdD6K6ls0EE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-14/kE40Vo7frBkV4pAwac4fVzktfCfVRdIRe1nJR5gI="; # aarch64-darwin
      };
    };
  };
}
