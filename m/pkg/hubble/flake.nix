{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-hubble"; };

    url_template = input: "https://github.com/cilium/hubble/releases/download/v${input.vendor}/hubble-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 hubble $out/bin/hubble
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ab2n4grzOKtylL/skH2DLk/MROYYA/hIBadyPTrm2sM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-BdmXqHvzIdLI5rTyluNrfeDXj1H5zNJXk6DGuGspxr0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Zve1u6N2oZ14N0/ktBOxPKba8zyLkoQs/7MamFEpnc8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-A8xkzhiTcAhY0o8GP38ckZWR0eRIPhw+K6rYEQ/Ft2I="; # aarch64-darwin
      };
    };
  };
}
