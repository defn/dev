{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-L7mUdMD1d14vVr20TVHt1ZodBtoMCJ8nvPSjtBFzi6E="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-YZIDxSkewga3jvBSDLFEWfQA6TuX/BnznURV/320p/Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-6ivuneua4s7GdWCxLuiIStrtVN5WDhxNlrTo7yPEVms="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Y7y/6D240Ug8I81oJruryCaYhTyMvTbbADa16UvVr2U="; # aarch64-darwin
      };
    };
  };
}
