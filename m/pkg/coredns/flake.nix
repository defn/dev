{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-coredns"; };

    url_template = input: "https://github.com/coredns/coredns/releases/download/v${input.vendor}/coredns_${input.vendor}_${input.os}_${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 coredns $out/bin/coredns
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-uzyOJKTsflxxPxWfX5QD/uLKDUZ8eJwrJfrXM905WBA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-EvTldfpOMHumLjrerSoUFsKDUPTKSDSj822rcADR2AQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-K+Jyp3bEZ0g2J9GX6qcGuWMeGd0npaRgfvaliIVs4AM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-K+Jyp3bEZ0g2J9GX6qcGuWMeGd0npaRgfvaliIVs4AM="; # aarch64-darwin
      };
    };
  };
}
