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
        sha256 = "sha256-39veZPV6dme9z1kGxd+M6vGfsxdcGzUlNO0iyni3pMc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-8yIgNGes3D+h5Wx3o0+5uPg4wXQtFLWw4oOt8yYQBPw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-/Dx7YZUv3YoHP4ifiNqNBP+oHYu8y765MmK5g8y4sNI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-5N9lTsBZkUmw0UuxLhm9ZrZV5uQMQ8ahi1lTxknkSGg="; # aarch64-darwin
      };
    };
  };
}
