{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buildevents"; };

    url_template = input: "https://github.com/honeycombio/buildevents/releases/download/v${input.vendor}/buildevents-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildevents
      chmod -R g-s $out/.
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-YOIp672gq0L/ySkM9jsFKbsCyv+pn6VPTCKDe1NZUcw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-FxZSZUCo2tR8xyiVBir1TSlsxCfseR7oYfw081MFSCs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-KVo2aIyn4VTuJwr4d63MCdxPI5NWPtdU1l544vh3P6E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-mweCf7dWftcJLefhk3djxN7vk+7N/zpnfqZIt3Jo0EI="; # aarch64-darwin
      };
    };
  };
}
