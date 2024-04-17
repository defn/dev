{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-earthly"; };

    url_template = input: "https://github.com/earthly/earthly/releases/download/v${input.vendor}/earthly-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/earthly
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-bXLSA7S6Xr8xJNCcQUk/g3CwXwQrePk0UMbQ4tHLIks="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-9ac0kAhe0KKCzsaYm8dNJdox4qWvdGKqGHTtAgXjxTI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-yyf19T+rcjCZxKKs0EiHmxn/5+jl6zNkP4cIhM2eIbs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-OCNS/JIGZPubNE0wKbWPvCWMaCbg0d1BHXC3xmPzKAk="; # aarch64-darwin
      };
    };
  };
}
