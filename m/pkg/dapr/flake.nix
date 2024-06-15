{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dapr"; };

    url_template = input: "https://github.com/dapr/cli/releases/download/v${input.vendor}/dapr_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dapr $out/bin/dapr
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-sl86bMtW6r/AbNuO8y4Wwpg9Ys0CAGeWhey02H+emY8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-8lbrdNEmcxsvkempNyNeKAemsPKGcQJj1VhI1kOaFRs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hCUG1RqWDydH6u6RW0DBmbMnj1uJgE/j+J6z3GPaNx8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-gtm3VR76F3RNPnCvq/ufCEfJkmRA8nez3UucNmqggWs="; # aarch64-darwin
      };
    };
  };
}
