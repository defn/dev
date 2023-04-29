{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/cli/cli/releases/download/v${input.vendor}/gh_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/gh $out/bin/gh
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-o+KYfknt5OkOAZL2TF4UgNah7jGW1RpPz74MzQpid0c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dekEm9XOqAhAlbOBvyEQO/i2CfmJyu7iCkcCOy+hy+k="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "amd64";
        sha256 = "sha256-3kUski8Wb4n0wjkIeCxvxdMhm7EY/cTMzqfu2QdzMZY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-3kUski8Wb4n0wjkIeCxvxdMhm7EY/cTMzqfu2QdzMZY="; # aarch64-darwin
      };
    };
  };
}
