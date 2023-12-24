{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input:
      if input.os == "darwin" then
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-apple-${input.os}.tar.gz"
      else
        "https://github.com/zellij-org/zellij/releases/download/v${input.vendor}/zellij-${input.arch}-unknown-${input.os}-musl.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 zellij $out/bin/zellij
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-kgPaKIcEK02KOydT5HX4Evpgr/aVX/vwYywPv8+qSoE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-8MZMb97xQLyd7Y6mT7T0qP1QBOhRLwRYL3SfIx1jnA4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-w0YarctnLJy8n/75d9RZOUMBJuv3y6UjHPvVoULZTM0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "aarch64";
        sha256 = "sha256-dNJqn2dcaOst+Fr8nwLUke1yVc8gozavRvyMEdKqZ4A="; # aarch64-darwin
      };
    };
  };
}
