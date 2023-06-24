{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-xP7xpMfknOIAZJO5qolLKL4keYeVlpi5fedxwSnM6Oo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-95WmkD2q33ZKUJJZm/5pRc7ddla+83iEowSawaUpJmw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-e6bPegKiA+GXhGTwlVEWTMrLmu/P740+xz5nr0ZBepE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-yN3TI9a3FBBeSwW0i+umtPV8VSRkrv1GkdAYv/a0w2I="; # aarch64-darwin
      };
    };
  };
}
