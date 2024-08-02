{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-tilt"; };

    url_template = input: "https://github.com/tilt-dev/tilt/releases/download/v${input.vendor}/tilt.${input.vendor}.${input.os}.${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 tilt $out/bin/tilt
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "x86_64";
        sha256 = "sha256-VcgoaI7oLjkoFvkPDP6i2NuWQsKAEI3KR/AAqyQplxM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-KotHgqrekByIVDrO2btMuQR38NumKrdZuzkRxXf95oo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "mac";
        arch = "x86_64";
        sha256 = "sha256-Tb/ZXv5PGQjLGiFLglORH4+zAAKPyCACdSVwqVTQCy8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "mac";
        arch = "arm64";
        sha256 = "sha256-rENTtgxCJ8O4BkaDgtPilkkKtzcvnSgHIW96xr4FOs0="; # aarch64-darwin
      };
    };
  };
}
