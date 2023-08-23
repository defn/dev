{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/loft-sh/vcluster/releases/download/v${input.vendor}/vcluster-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/vcluster
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-vV/sakxqzhFs7OfYR+vE9Ep4CKN9sZFaIYYTJ14+zCQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-54UWhdfD6SxMkZiZwQbE74ZW160w9RmNMGgN3w5Mer8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-jLnvmjNX3Ztn+NmJZnAIwjxnbB54bf+xCMO53y378ac="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-yk/Le9othE1GrWJPClkcJkNpPggLhnOCUxEBJ8+DAfA="; # aarch64-darwin
      };
    };
  };
}
