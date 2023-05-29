{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
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
        sha256 = "sha256-3GQRc8vaKbpIWAzd4/gPenNPO1WKJeWVCksZ9SJnjHA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-UX6W+dA2xLd9sBEyys2+8h5CZumtOpPmd3PFkLpU4m8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-D1HL4ZoxW5GehwQvBIUzGCFyLst/ziLMG4gO1IM/yLA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VSQqUuvKQ9+xM9D+JuEVRr+kVxrd1oUteCwRnXTereE="; # aarch64-darwin
      };
    };
  };
}
