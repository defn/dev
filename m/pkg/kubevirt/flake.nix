{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/kubevirt/kubevirt/releases/download/v${input.vendor}/virtctl-v${input.vendor}-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/virtctl
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-nEzxiAfWg8b4yIhVOz1xGj4KQL9I+Sf9z1kFRAqkFsA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-nEzxiAfWg8b4yIhVOz1xGj4KQL9I+Sf9z1kFRAqkFsA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-MJWfE1ZHSCLBX0vvH4ybBTrglhTo8ziA1B30UQy4CMc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-MJWfE1ZHSCLBX0vvH4ybBTrglhTo8ziA1B30UQy4CMc="; # aarch64-darwin
      };
    };
  };
}
