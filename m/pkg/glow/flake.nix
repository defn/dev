{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/glow/releases/download/v${input.vendor}/glow_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 glow $out/bin/glow
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-ROAqfgK23yOYMR6lpgc9NcJkmxCbacF0A5Gyv/J3CR0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-BYH96qkB8Gwc2xqoZgWlLCdizNTQsFrvzirB9EyC9MU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-oE1fR1mtEymWUvA2L+hYbKd7OZ5m+Jm9DJ9zqNTcRmE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-6swuY8BjgMoOXJmjzqjJ6rUhLTeCMCHmd9HyqPfURkE="; # aarch64-darwin
      };
    };
  };
}
