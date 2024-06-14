{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-argorollouts"; };

    url_template = input: "https://github.com/argoproj/argo-rollouts/releases/download/v${input.vendor}/kubectl-argo-rollouts-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/argo-rollouts
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-VhqRtmXOruqshMdV/DXIE5T+MrIY23abztwphnoBLGE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-t1EzoX+rNhv0QMrvJ7rvQ6jtibFxRLw0kNBtXM1jHy8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-epbdsmWv9m+v3QYdtKmTZJYB4TgANQPTIwd2b+GR8vc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-L3vryRrm8smh531BbNBH76JNxiYm3PHNSMmiSDK8vZo="; # aarch64-darwin
      };
    };
  };
}
