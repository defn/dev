{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-honeytail"; };

    url_template = input: "https://github.com/honeycombio/honeytail/releases/download/v${input.vendor}/honeytail-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/honeytail
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-vCay3ErgA+GOYAxBVxIfYm+SkiAdC5YoDJKY34HfGFI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-NtIQY+ZWs4DWQ1ADpWshAHKJqwR7FXxWGNK5S2lioP0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-BN5FxVuzQKTD5U5Ftosrle+Mrj+8DHDYbbddE9Cq6yw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ohaLTedzdzCoFhwD6VBbZ8bMytBfv+6njs79zJAIkSM="; # aarch64-darwin
      };
    };
  };
}
