{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-E/r0C2ObFZfXkbrM71gc1y9JSt1p07kqrU8jqeCAz8M="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-rcDYQcyxChaiLaAKHzqZOqydW+WAPx90bPkVdawA758="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "amd64";
        sha256 = "sha256-FK0kRgleWhjEnH01MPP1DMBC9Im8H9kmhw9tn+LNs1c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-FK0kRgleWhjEnH01MPP1DMBC9Im8H9kmhw9tn+LNs1c="; # aarch64-darwin
      };
    };
  };
}
