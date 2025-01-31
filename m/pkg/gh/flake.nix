{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gh"; };

    url_template = input:
      if input.os == "macOS" then
        "https://github.com/cli/cli/releases/download/v${input.vendor}/gh_${input.vendor}_${input.os}_${input.arch}.zip"
      else
        "https://github.com/cli/cli/releases/download/v${input.vendor}/gh_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin

      case $src in
        *.zip)
          unzip $src
          ;;
        *.tar.gz)
          tar xfz $src
          ;;
      esac

      install -m 0755 */bin/gh $out/bin/gh
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
        sha256 = "sha256-V1axbCs4dSmNdH7p43SPRLHcjkiAq/ICbq/wusc/wGw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-QyeAwu+Srir89/iTY7vr1+EezxaGF3r6hakz3EMLdb4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "amd64";
        sha256 = "sha256-GQO7/c7uLTzGr8DNZDffW2Mw2HY9zuldCbUaxXS2qtM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-GQO7/c7uLTzGr8DNZDffW2Mw2HY9zuldCbUaxXS2qtM="; # aarch64-darwin
      };
    };
  };
}
