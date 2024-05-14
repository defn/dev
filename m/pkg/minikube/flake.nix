{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-OG6yZ+CxwfAA8beSQDFVdAL//EcEMtwjuQgfxpYv1ps="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-C2oX0jC0pgUAKYHx66L1qj8hUzYaGrAAwB56lYMLQLo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-bhw5EcObjeazyjEof1W08H7zKc1LntYr8IN4wpdVgN8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-fmI+ybV2RoG9kbJy2DPd3slFJyd8NCvEWCQjidyKIko="; # aarch64-darwin
      };
    };
  };
}
