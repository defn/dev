{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
          tar xvfz $src
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
        sha256 = "sha256-F/PCHz9MOwF1qaDuj45C429Y4nE96BRA6pwMuUxaCKg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-L4UEMPMAsMwlscm83z/lGgud5XdTTX7noPtks4vf0og="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "amd64";
        sha256 = "sha256-LhlAcvV9Bl8g4PVo0BuAwqBvXtsDYCGgj1DxlKv5r8Y="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-LhlAcvV9Bl8g4PVo0BuAwqBvXtsDYCGgj1DxlKv5r8Y="; # aarch64-darwin
      };
    };
  };
}
