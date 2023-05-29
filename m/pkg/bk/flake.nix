{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/buildkite/cli/releases/download/v${input.vendor}/cli-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/bk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-57A46c/sdgbDaaZFeyGemiG6LMH9EHqkSlKVzjZBEkU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-/Q+fxPuhU43iW56JMOz/1oU6aF/DtjBOoeQWspv/ZJc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NOOH9b8VxkNex/KuCoRKYJyesbmXxHkKV7tJT5Oo8/0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-NOOH9b8VxkNex/KuCoRKYJyesbmXxHkKV7tJT5Oo8/0="; # aarch64-darwin
      };
    };
  };
}
