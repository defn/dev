{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-opentofu"; };

    url_template = input: "https://github.com/opentofu/opentofu/releases/download/v${input.vendor}/tofu_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 tofu $out/bin/tofu
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-2og2T3qJLAFDvfblKdl2SYzpQ5EP0IQCUP0if5g7VDQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-EDUlBLsOV6EiP8WF4G6Jb0A15YXWNMWAX65uo/dFcSw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fZ6gUaJJ7O1b3GEgNx4E9H6hOu3Jt1Z0IJEj+ZfkPAE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-5B/iUNXzjwfQRNBkuAcPgsIgj6oi6doNWmbwHYJSasg="; # aarch64-darwin
      };
    };
  };
}
