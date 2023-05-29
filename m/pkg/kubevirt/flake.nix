{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-ItK0fG9ypo8h50XGbzYyAQoEmU/rPm3xZPe8T0tFsL0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ItK0fG9ypo8h50XGbzYyAQoEmU/rPm3xZPe8T0tFsL0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-h0FDjuZgfCjW11PZexmUZOEy2Hk8bJiaTLSFwCOmflI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-h0FDjuZgfCjW11PZexmUZOEy2Hk8bJiaTLSFwCOmflI="; # aarch64-darwin
      };
    };
  };
}
