{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/coredns/coredns/releases/download/v${input.vendor}/coredns_${input.vendor}_${input.os}_${input.arch}.tgz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 coredns $out/bin/coredns
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-+Wze4JNMXBKii7D7CAvtaI/de/3q4vZJhPAr3sLWVJg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-cl7ml7Rf/wx31juTGXcJCqDpOmF6eC6sG8Spls4CSOI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-MaIDSDPmk925tBNm3qBdruudmaErOR5H2WF7VbQgdCs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-MaIDSDPmk925tBNm3qBdruudmaErOR5H2WF7VbQgdCs="; # aarch64-darwin
      };
    };
  };
}
