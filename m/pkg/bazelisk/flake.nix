{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-bazelisk"; };

    url_template = input: "https://github.com/bazelbuild/bazelisk/releases/download/v${input.vendor}/bazelisk-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/bazelisk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-j+3k0f3oAVkNbnz5GecF90B2jVauONVdRzU2cUcZrwQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-7J4MZyATJbu3BKvP6fqPhKuNZJIM8MZyc8avqXU3H70="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-2lGNkZnUOhVBBU6Qs83K1NSyBWkHvBuFlAWZLiqXFPE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-mmPAw+5umbPmZMWWZnoCmArWREDuC9AcP6CZrBR7ZTk="; # aarch64-darwin
      };
    };
  };
}
