{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-mirrord"; };


    url_template = input:
      if input.os == "mac" then
        "https://github.com/metalbear-co/mirrord/releases/download/${input.vendor}/mirrord_${input.os}_${input.arch}"
      else
        "https://github.com/metalbear-co/mirrord/releases/download/${input.vendor}/mirrord_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out/bin
      install -m 0755 $src $out/bin/mirrord
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-jea+jzrmeY/L2c4vUXvTSyE1UoePk4uuniIecSXiDXk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "aarch64";
        sha256 = "sha256-Tay/8rE4EzrHjX3pBQgIYp/GDebm8d5b0z4e3dx+m5I="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "universal";
        sha256 = "sha256-DzygFulDjt/FcuYr16zpvjbGRSotg6+WKTgHDhnFZCw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "universal";
        sha256 = "sha256-DzygFulDjt/FcuYr16zpvjbGRSotg6+WKTgHDhnFZCw="; # aarch64-darwin
      };
    };
  };
}
