{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    extend = pkg: {
      apps.default = {
        type = "app";
        program = "${pkg.this.defaultPackage}/bin/coder";
      };
    };

    url_template = input:
      if input.os == "linux" then
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.tar.gz"
      else
        "https://github.com/coder/coder/releases/download/v${input.vendor}/coder_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin $out/lib
      cp coder $out/bin/coder
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-eUrP2f1J9LgUuLSMyb672wtpSgsiZ2zX7r16+KpQe+I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-yzhK2ukTxuI415fMKZrdwBsVTVxOn9sXLt904WfMdM0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-ClNArQiYfeyk7K/4GUYfbmpcCM1o1UYQ0UA/rTEXspk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-qxPlQyzs2NlMj3X6fxu0bz9bUaHUJEIivCoRiaMyehw="; # aarch64-darwin
      };
    };
  };
}
