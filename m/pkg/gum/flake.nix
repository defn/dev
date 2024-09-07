{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */gum $out/bin/gum
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-7oG3zL6yBf7FAXU3HXh671onuDtgep189k5aiPv8C1U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-0GK0spNPJsy0wu0xxtsZ+j8BHZaeNmAgs5vAk0zdAOI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-ABidG4c6n99Uw+CB8rAuaouj2Pj1vs3J4pNW73ydX6I="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-C9jmwYAIRlRyj0PAqa4K/XumQBpfvKyZy7Lt++rSea4="; # aarch64-darwin
      };
    };
  };
}
