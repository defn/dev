{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cloudflared"; };

    url_template = input:
      if input.os == "linux" then
        "https://github.com/cloudflare/cloudflared/releases/download/${input.vendor}/cloudflared-${input.os}-${input.arch}"
      else
        "https://github.com/cloudflare/cloudflared/releases/download/${input.vendor}/cloudflared-${input.os}-${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      case "$src" in
        *.tgz)
          tar xfz $src
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
        sha256 = "sha256-37MwdoYfqkzK2x0womPxgceHfC1X8XYQAPvLdIvUo1E="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dvlBGLT5WNQN997OwpIGH8kmqBf1ZBcy5esnknXqjkY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-HeAK/00gtzIAkiSrqi0YeI9R8Vnh4uzrE9KODra2A4U="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-HeAK/00gtzIAkiSrqi0YeI9R8Vnh4uzrE9KODra2A4U="; # aarch64-darwin
      };
    };
  };
}
