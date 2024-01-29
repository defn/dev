{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-gum"; };

    url_template = input: "https://github.com/charmbracelet/gum/releases/download/v${input.vendor}/gum_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 gum $out/bin/gum
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-1H60Rv3tsDd51099msh42Y/9isFs8ESVc9f3xWxnDn8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-e8e14bDvovGDHGmBv3ImLaRzPogRb/ZxyB+qILepRyI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-fcnrYCcIPSe7EGdurQzdeWM2ijFeUFcI5DkNFZhHzlM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-I3TdfQZwfDNy5Sby5saS+Cblu4MJXD1K8LDhtfiut/o="; # aarch64-darwin
      };
    };
  };
}
