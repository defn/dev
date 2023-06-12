{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/dapr/cli/releases/download/v${input.vendor}/dapr_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dapr $out/bin/dapr
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-muu3A9FbDSzNTGx9pHGWJ7DF8rkcaZpBdFCg7DANi3k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-nXvNXue4alJjgTuhQ2MwuJFq6Rm2ak6JlzpfGT6fJrA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-FGCUP6nH2jYAkD9Y2Z/fkQurDutMxCccUjB1fkryEd4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-DKd5dox4Y90FMIdnfeXsNJyW6rrC8oK7ecqX54wnT34="; # aarch64-darwin
      };
    };
  };
}
