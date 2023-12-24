{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/sigstore/cosign/releases/download/v${input.vendor}/cosign-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/cosign
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
        sha256 = "sha256-EhugAxgnwJA2SJRogEllHToKgqhyNcRpMiogKqKUQhE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-gutivn4beSTbGT1KSkluypRRDfKWHYhAa6B/s0Nfbo8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-49Q9uYK2Qr4VpiLjeRSAYg9efy6QKrDJ4tsh2qo2JZ4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-eHRATOipspJR/0hcbstG7P69ax9fo8ts0Lm/LHW6stU="; # aarch64-darwin
      };
    };
  };
}
