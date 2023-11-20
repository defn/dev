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
        sha256 = "sha256-mROnLSA5UZdsufP4jmgWujRfBQzIlAZoYs/1N2tbOjg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Y+aqrXCcu5HBrJLwc6YNPllgT3u2/TCB0MZDtW/Ky/U="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-yL5CwULsNelLYJyaDkx6lIZTgyn5PqP6r6zyRtmoqbU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-04rJF7OPvEX8L3tSZKwH5mPQ6ZHiHMjVOPpcW2NC5EU="; # aarch64-darwin
      };
    };
  };
}
