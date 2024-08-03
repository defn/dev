{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regbot"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regbot-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-D/hqcFl9kXs7kc7zbMpDsT78/DfBlOK3jj3xdQYE380="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-95Uv1hjj1JjIYxg8PTFTLojwpksxFJ5ukCEY07dhfnc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-i/4+xAbSYSiTwqmEYmbPbxYluCA28QGLrosNxJvpbv8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Ngu7zXgbdfZtEH2Bc3g5EvfOPOL+j6QDMtu2u+HyTxQ="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regbot
    '';
  };
}
