{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-kubevirt"; };

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
        sha256 = "sha256-EbctknvjIkjtV/XvA4H9YiRlzn6xxn7rbBiRBumAPpI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-EbctknvjIkjtV/XvA4H9YiRlzn6xxn7rbBiRBumAPpI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-RGOw7owHi4l411PeX47vZZ24VbcWLeyUto2OSeh4Vs8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-RGOw7owHi4l411PeX47vZZ24VbcWLeyUto2OSeh4Vs8="; # aarch64-darwin
      };
    };
  };
}
