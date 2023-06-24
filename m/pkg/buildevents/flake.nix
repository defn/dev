{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/honeycombio/buildevents/releases/download/v${input.vendor}/buildevents-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildevents
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ugvBXsPIRZ4GrDjevLdeoppz4pTjNwJxcmw/FPT+Woc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-WtuHbLgrcp2JaPQxlJBRlu76uIN1iFS2hcZhYJGZSP4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Um5eHyPaZs6TT+ad77RhJ5kdj4w/EK82B6bDOyKDeMk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-LRamfAf0c6pANolR9ZeuiLdJB/oAu9lWum5/0TT1k80="; # aarch64-darwin
      };
    };
  };
}
