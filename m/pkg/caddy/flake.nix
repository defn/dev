{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/caddyserver/caddy/releases/download/v${input.vendor}/caddy_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 caddy $out/bin/caddy
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-tBQlRQMPCdDon+yp6pkG6nmvQuPvPAUAl52vrg40mBk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-mjEVlrZ6yT1aWTf7LdH7YWVxKNTiv7QYmMkICZpWgjk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "amd64";
        sha256 = "sha256-9DKzh3ujJtQaXn0V+TZBhWBKJuSmJgwN4J/ABAOhfNQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-YTJtVq3hg2Km6UqygHVqFkOQo1EkQC18+lUKStK9gj8="; # aarch64-darwin
      };
    };
  };
}
