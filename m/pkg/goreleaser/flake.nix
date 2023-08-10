{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/goreleaser/goreleaser/releases/download/v${input.vendor}/goreleaser_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 goreleaser $out/bin/goreleaser
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-ZusKIA40x1C3DFuqKHtmGxZ8VEjjhxEUt+K+xeo6OVw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-QYPVt3xRr50QEoXYeOmaMDhwiQBaDwr7ZNk6CnNnZ+A="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "x86_64";
        sha256 = "sha256-tZLGhiffUdhcYLPoq1b6teEHFDHrlGbRMZoBHH4Mwkc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-vcCCRfRLIOSSpnO5C0CnaMB38ACmn/9rMimc3Jh+X0w="; # aarch64-darwin
      };
    };
  };
}
