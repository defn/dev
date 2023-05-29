{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.9?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/honeycombio/honeytail/releases/download/v${input.vendor}/honeytail-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/honeytail
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-C0CEPncDpRB10p7OlSUk1ujpzIm+QX+PtX9uyvJ2bGQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ZWeKANDpTiVMzVGgTro1MTg72OcvOx2qjT2IChDtMAw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-PUqpZ0QydDb7QSbQe+5kEun7xX1XIUQTjot2NDw7MCw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-wGl4J20ULeh/2hyYP9pEbSd9CC8Gj41D8MGZipGrCKk="; # aarch64-darwin
      };
    };
  };
}
