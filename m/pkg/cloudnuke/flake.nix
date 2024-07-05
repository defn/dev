{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cloudnuke"; };

    url_template = input: "https://github.com/gruntwork-io/cloud-nuke/releases/download/v${input.vendor}/cloud-nuke_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cloud-nuke
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-nrXrWu82oKN6o0WBcH3yY+pkfABPThMEpM6sjW8OfwY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-BhgAGFg8ksbaKkvfWdymDsAcr8gnEhHVb6uEnKsxPro="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-GsdB+g/qlyqQsy6F7GJLhikMKk8lv5+LFK8UMlk9DME="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-vPdqfOoUwHvng4EJYXoj4hlAx1MrbzCZTwZX3tmSN5A="; # aarch64-darwin
      };
    };
  };
}
