{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-argocd"; };

    url_template = input: "https://github.com/argoproj/argo-cd/releases/download/v${input.vendor}/argocd-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/argocd
      chmod -R g-s $out/.
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-lWUfgb9mM5MHp8wPmw2i5D3L461G04CTP6nSjOb8RRE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ikQPCwkvMjrvetCsjuE/rW35uw1Xfit2GUCza+PiZlE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-3DpKkTtTY22iUSSfCV+m6+E7Vqii6ZS+4jDSwMwa+8c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-O2BCP5Yxz+AOrXBOK4NNi07ltyCFFMG8mlPcu+wzSEE="; # aarch64-darwin
      };
    };
  };
}
