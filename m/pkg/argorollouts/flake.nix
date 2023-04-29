{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
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
        sha256 = "sha256-hDsrlpRy5d11/2Suv4uqo1P4tgeZCS0Qxu9+45DSTQ4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-u/RhKMFXsX0Xujg1/ImiDxGmWU+xl3uJJeIEitVFZLk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-XzYvWE3yWAzep3Ro/oXAxI0xhF4t1kWyas0k7S2B/Vc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Q6tgw/6OmGUjgMCMbXX5N420ssTH+NePkse6Gzjg9dQ="; # aarch64-darwin
      };
    };
  };
}
