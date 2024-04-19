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
        sha256 = "sha256-CSbgwTjO1J4L2nKjBJ1+zeuiDIL0xW4Vsy2JCm4xWKE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-bR+KrGOnkq43HOmEjRHE/YbR5at0NZyfYhM2Ix//rao="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-An7JzviDv8M48YdI2qvZR075zRtGkyJH9wxjat9FFD0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-AnGXdBWtrIWspZ3DY5o9Sfak/N8Ka8zcbx7Mvsz5drw="; # aarch64-darwin
      };
    };
  };
}
