{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/vmware-tanzu/velero/releases/download/v${input.vendor}/velero-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */velero $out/bin/velero
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-DU2w1QgdjDkm0U+9rii8Ws6bnQeiIp1fMHfjL8xS5Xk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-1GNJy2ZgKGFco13WqDfJdqdoBdDxXgsFrhR4O8b6kWA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Jc57AfuF82n0RQZH+W6dp39tBsUfPjyQdRgsbgA0yvc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Jc57AfuF82n0RQZH+W6dp39tBsUfPjyQdRgsbgA0yvc="; # aarch64-darwin
      };
    };
  };
}
