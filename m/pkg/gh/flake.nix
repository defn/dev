{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input:
      if input.os == "macOS" then
        "https://github.com/cli/cli/releases/download/v${input.vendor}/gh_${input.vendor}_${input.os}_${input.arch}.zip"
      else
        "https://github.com/cli/cli/releases/download/v${input.vendor}/gh_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      set -x

      install -m 0755 -d $out $out/bin

      case $src in
        *.zip)
          unzip $src
          ;;
        *.tar.gz)
          tar xvfz $src
          ;;
      esac

      install -m 0755 */bin/gh $out/bin/gh
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-UyYz2FFVfR2oDVmt3LP3uiC6A0HImQ0y0T9K9z6/s/A="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ibA1HSQhwQ3SfpHYruE6l6/pUDlQeiGmwKOomeKsHZw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "amd64";
        sha256 = "sha256-HlCmPO7k7NV0kYTarqufdprTmqH0KvBpozdg1pTkQg8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-HlCmPO7k7NV0kYTarqufdprTmqH0KvBpozdg1pTkQg8="; # aarch64-darwin
      };
    };
  };
}
