{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

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
        sha256 = "sha256-L32AVY+ZV/77VPsZ2D7G/GmT7t8vDOETv/JcsuuKjXA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-VjAc7zPIGGEAfHsqOakagMU4nTjv2seRbri0ODahLUk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-H1G049fKgQ2SLlJWIK3Vy7YqVb+YDCF2VQ0fS9hjEeg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-7jm1nVAJ6j9U+Twbbh98bcxw15xy9PGh63/GOap/hKg="; # aarch64-darwin
      };
    };
  };
}
