{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
        sha256 = "sha256-3elDPddROOgJUr4DXqgHV0Utj0sqlA+2/vQv3vZ/KcI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ck+osc2+NNLBREtkKAHu1/3wVnmMf/Jh4yECTauukcc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-SHps3xuZ2hZTuEJ4vLz+W9HcPf+pB1+fbjgGsyTSIB0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-wsE5UUkWcg+CrqcMeaV4BMoEgZFkuhVrbqO1F1Nr5Eg="; # aarch64-darwin
      };
    };
  };
}
