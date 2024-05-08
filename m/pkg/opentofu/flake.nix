{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-ZWe0nEPt0uJnCJa7Z4i1guejD6bJ7p+ge55hPPshmHQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-J6gKnk83bsvTNoIbLUGtp5evTjhXFPs0i3I04hvu7L4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-+6kP1n/sqbNaHkxEyu2bkWjs/v5F35RjsjYCtiXDTS0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-SkTcMBndHOv0X2/THU48RnnWKy1MOkrBuORME/bjE7s="; # aarch64-darwin
      };
    };
  };
}
