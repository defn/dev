{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-oras"; };

    url_template = input: "https://github.com/oras-project/oras/releases/download/v${input.vendor}/oras_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 oras $out/bin/oras
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-QYC5QECauAGtpUzbeT3XNyvipcsltlIkkECdXUsOPd4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-ZfkZfp6s2nabHy9EfixABKjz93KFXCyYfVER6DAsu+0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-VAlduaTLDze/esWvvtD/FnIVGVrQe22TGLacWolEsZ0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-40icGUbLmMIZkuCfLsN5dK04VruIt5hoKXX855YPCP4="; # aarch64-darwin
      };
    };
  };
}
