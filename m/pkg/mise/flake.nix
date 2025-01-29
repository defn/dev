{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-/VTelbrNXZjBFu46dx2PZOoA5kd3Mnfk37892NGJT10="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-y2vUoDq+5HvLesd8N/05pHyG9mXKGZ5Ofoj6/StMqqA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-l9rqWaY7iR1AVjSZh8ko3yMs9zisLD/M4qfJRYNwBEc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-lZ+nlj0EHH7O0z34ngQHFBi4tlA6p7cp21wfHYmGd3M="; # aarch64-darwin
      };
    };
  };
}
