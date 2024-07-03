{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-packer"; };

    url_template = input: "https://releases.hashicorp.com/packer/${input.vendor}/packer_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 packer $out/bin/packer
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
        sha256 = "sha256-B6nZL+mNe7S+CTksBu9sT5/7yQX+bCn/8GIkMjZ/Acw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Jmb0C95T9GhLpaPVKjjALWukX9EUw46moJJb7dLhatA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-CNqrU/oO3uuV1E2T3+eOKse2Z+HDXGoZx+3GZZZ+dCQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-hiYkITWCgs5+ZKgFBZAkht2R7OgI0YhEN0fEergOaG0="; # aarch64-darwin
      };
    };
  };
}
