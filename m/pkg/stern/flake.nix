{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-stern"; };

    url_template = input: "https://github.com/stern/stern/releases/download/v${input.vendor}/stern_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 stern $out/bin/stern
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-6hvx8d3fH9S5lxFIWC6IxjeISsFZLcunGDimpCJ3cIs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-kbZBZItNz2rVeHM6kTJ/erKvljjNrNnAkd1Z4pkr4fA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Tq+PDWCSSQKj3aGq67Vzo3YTe7gw9FcD16C9ieiESUo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-HGeWWqqVMO2molypuSwdC0VEcesNzHhEooYXaUxELq8="; # aarch64-darwin
      };
    };
  };
}
