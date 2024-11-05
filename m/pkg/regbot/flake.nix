{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regbot"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regbot-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-hjiIkVK8wHcLmDc/+4dja4hCS6Oqd/WgBR5IKV2fhZE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-SPQ5B2B2b6nZtl7LFuqC/T9ZjHKUvtWtwqOJm7UsCtA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-HQXJcEoyfJT/I0jRgRsF5A2Q9zkiSbStMGVTQ20XtuI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-F6rxQN+24zx4NJGc++EwwowSuUfaE3oqdeya2Nx55Nk="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regbot
    '';
  };
}
