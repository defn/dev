{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input:
      if input.os == "linux" then
        "https://github.com/cloudflare/cloudflared/releases/download/${input.vendor}/cloudflared-${input.os}-${input.arch}"
      else
        "https://github.com/cloudflare/cloudflared/releases/download/${input.vendor}/cloudflared-${input.os}-${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      case "$src" in
        *.tgz)
          tar xvfz $src
          install -m 0755 cloudflared $out/bin/cloudflared
          ;;
        *)
          install -m 0755 $src $out/bin/cloudflared
          ;;
      esac
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-iTKetO+EW//VlkZWcoiOJuWuFuqD+JZv6lvjDzSWUq8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-7VwqDuzd23FKFB5Dj3hseogo18w8Kow33YIvIZJ0Z1Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-FUOV+PfafDr3mfc8BzhuFuFiFSy7HYoekDXbcGwDaHw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-FUOV+PfafDr3mfc8BzhuFuFiFSy7HYoekDXbcGwDaHw="; # aarch64-darwin
      };
    };
  };
}
