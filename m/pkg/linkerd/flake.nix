{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-linkerd"; };

    url_template = input: "https://github.com/linkerd/linkerd2/releases/download/${input.edition}-${input.vendor}/linkerd2-cli-${input.edition}-${input.vendor}-${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/linkerd
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "-amd64";
        sha256 = "sha256-SgmuqtRZjZ1Q0dkLPM+2ouJxpleNx3a1nclljyTy7bg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-np3Lh1sBWCuxd9QlTemwjCeKTANYXcmjiffzGkmrD0Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-+AaLUYWS50LlnL6UgbnIcPw9L4pKH9jgOLiv/uIyLxs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-K4fnvgDDOM/gOlBwdJqFSk9+lBLHLxAwV3ACmTEdGKo="; # aarch64-darwin
      };
    };
  };
}
