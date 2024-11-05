{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-goreleaser"; };

    url_template = input: "https://github.com/goreleaser/goreleaser/releases/download/v${input.vendor}/goreleaser_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 goreleaser $out/bin/goreleaser
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-cVCB4oupyB/9GzkU+mDZ3fSL94YgHWiegW66f6g02i4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-vMXBj+JOeVLvdgvw4M+9eKIiAF6KAB9BZ+guiyvqmLQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-+jYB3Ba0BV19GDzCSXrdnaNZ+Yk1fYBgMikxMM6hldk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-J5VupG6F+bqgqo8+qQZ0ySGPLtrs9bTGgjtlv19he3M="; # aarch64-darwin
      };
    };
  };
}
