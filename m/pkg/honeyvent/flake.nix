{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/honeycombio/honeyvent/releases/download/v${input.vendor}/honeyvent-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/honeyvent
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-OBCtbXCDbVtPLvXeJ8PIo+1PNbszFjUTfUQiPihdb8U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-pIC+KlaiDkhZjW359oJnMRXOfuT1hkaw4H5Batfaw8c="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-yayquKSKozRf0yPEMVyKrKUrL2zkxvg7b6FizUxRZyU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-yayquKSKozRf0yPEMVyKrKUrL2zkxvg7b6FizUxRZyU="; # aarch64-darwin
      };
    };
  };
}
