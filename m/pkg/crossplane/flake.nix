{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://releases.crossplane.io/stable/v${input.vendor}/bin/${input.os}_${input.arch}/crank";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/crossplane
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-MvnmuMn+eUlvnOdi00Gt3d1wsry4I7FOAynRDc6KalU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-CiYtJF2WdVAH8tN2S7Zjod0zIk699WKFm4uViRNz+vc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-WeCtQdnu/5jpdYpy0lI2q/MpXXP9n5zkoJxvJxD0MzE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-WeCtQdnu/5jpdYpy0lI2q/MpXXP9n5zkoJxvJxD0MzE="; # aarch64-darwin
      };
    };
  };
}
