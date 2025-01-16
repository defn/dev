{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vcluster"; };

    url_template = input: "https://github.com/kubernetes/minikube/releases/download/v${input.vendor}/minikube-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/minikube
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-dTabLWRUMoQjK891eLd9QpU94hPR8Z90W0FFViOaPw0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-dVSb/bw/5IPAYOWqW4SDdEJlUtfjRt+L0VrXdTIkN2c="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-ulqyeJ7gxAzv3jB2Jlbzqgv0exXuC9gI89dSPMVNdd8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-f7CHfKJ9tL8uY3/UoxExuK+llHs38H0OQGOCoG4xnKg="; # aarch64-darwin
      };
    };
  };
}
