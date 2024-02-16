{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cilium"; };

    url_template = input: "https://github.com/cilium/cilium-cli/releases/download/v${input.vendor}/cilium-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cilium $out/bin/cilium
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-zaPxxAriGRolCnzqniw5h+qoHLZX3aVM2M4l+FbDhNo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-mqN9maFecrvLVV1+1biMKuOn5vvEePnuQCqDW6a0EXU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-5L0zQQlu/nkZcPuCJGoxqmLrtYPKa/+gkrxobeaAn6Y="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-tnoqkkBdyrdKfpDOzihnoySL2WI5n4t1MakVwG+kTfw="; # aarch64-darwin
      };
    };
  };
}
