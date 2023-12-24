{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-QrJnOA0yOH6Df5INgxNJSiCYgz1LCDR3xA2iFvuJ2r8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-XNZa7ZIJ56zr7eevjWddPfNVl3wn1i76Q9dwFiMilgU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-4Djra+n+CIFcczOFGNW3Zxcym3IMpv7FRs5mXAm2oa4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-C4jqT+yevJd1ea797q42ZwLa6keYWRz0qh3g8iLtIH8="; # aarch64-darwin
      };
    };
  };
}
