{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-zellij"; };

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
        sha256 = "sha256-3PccLGChYRA7t4sqoFFjA46dm5fCzaAMjtCMvp5KbIQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-iTG/5uASm/jnMKE2XR361CIMBfwoCn7v81E0W/RWFuw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-LX0p91cPiEFr7b2StbXQZFTJz4GtUjXQ/50QbZk9Vpg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "aarch64";
        sha256 = "sha256-zJlu6pwc6pXZB1RIzDbiZV0iXVulRHJOZT58gpwRYns="; # aarch64-darwin
      };
    };
  };
}
