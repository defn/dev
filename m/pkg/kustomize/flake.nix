{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-kustomize"; };

    url_template = input: "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${input.vendor}/kustomize_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kustomize $out/bin/kustomize
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-VOQDHdxOf8WeQI2innxkbo5XuAiMUbhLPfCGT0e1FI8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-rYq2LU9tWaiv2g7sS6LlzS+Gvxr+6kt40G2qyUXrBmA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NDK+l/n7SJkUi/JIXM+QgOXncCdY6xbJLNLy8zXhKgM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-eR2Ul9KXPUrxfJwMKzmRzoLmHRor959O943Z3OJabT0="; # aarch64-darwin
      };
    };
  };
}
