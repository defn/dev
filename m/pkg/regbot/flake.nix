{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regbot"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regbot-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-OzJn+AzAvk938x21odNX5mQzdCvTHlqIVfOpEYO23GI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-6xeKOXgVMAYS19t/1mgE5FIL65+TLlBDV1mDSSWrT/Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-BggqvsUmiM3SlZ+lZ5lIQd4G58JRcUDbL/2OZRiS1zA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-oIi7JyKE7LfviGeOhnBTi26Sgj7hCGfi7RHzm7w5qpE="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regbot
    '';
  };
}
