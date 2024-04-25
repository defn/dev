{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-tfo"; };

    url_template = input: "https://github.com/isaaguilar/terraform-operator-cli/releases/download/v${input.vendor}/tfo-v${input.vendor}-${input.os}-${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tfo $out/bin/tfo
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-nWyN2McNEO55AcKYKc1Vs/5nLLFeZQNlRACp5VuILo0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-T37iTMcUYVG/sR9U9whcTX+BaoQoZutUaQQRvMuDXbw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-TtDUPzVtxRi+Mcobu6sD3TLAuFo1a1tO8iMHkKHVXSo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-TtDUPzVtxRi+Mcobu6sD3TLAuFo1a1tO8iMHkKHVXSo="; # aarch64-darwin
      };
    };
  };
}
