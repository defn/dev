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
        sha256 = "sha256-13JfsqZDygJO31tOLyzKBDGkBLvC4lEIb/yisl43vhE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-FjTAGl1k1KhviEh7iYc9OXTWSpJNv9WHIZi/zqflpuU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "amd64";
        sha256 = "sha256-XV7hY0UlGmUkleS+jxkOwAIJKY9x42ZqgNk5TNARfOs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-XV7hY0UlGmUkleS+jxkOwAIJKY9x42ZqgNk5TNARfOs="; # aarch64-darwin
      };
    };
  };
}
