{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/honeycombio/buildevents/releases/download/v${input.vendor}/buildevents-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/buildevents
      chmod -R g-s $out/.
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-r1H6agk0hnhH/+J4gGeuOKZayHGW6Q0zTDdFkcR2zs8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Hc54MIBbDrN0LiClOSS9RsWSKk7KCvPfNIqFTQMkIoc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-gAdXSoa3n3m5RB4nloN+6u5mfShNdDlKE+ttHtPvtAE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-L9CtKk11pAKZdX5xM4sqxgvGRbNI0ltBS858SWxe54w="; # aarch64-darwin
      };
    };
  };
}
