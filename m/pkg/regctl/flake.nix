{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regctl"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regctl-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Pm54Ep/x66PHKOYIYn5VOydFJqVVYCg1HE6lIiemMDo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-/LQ0hG4Yqprj2r278EzqTeaV6Ve4oQMfMeDfejQsoBk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hPiEjxKretOkdtIYNQMlxWGQTUT5qE1dL2hTcyaF7H4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-A24OanFHmNMNV3r7UZssa8RpRr7ZeJFShrMmU4yGiRk="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regctl
    '';
  };
}
