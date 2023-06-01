{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://dl.k8s.io/release/v${input.vendor}/bin/${input.os}/${input.arch}/kubectl";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kubectl
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-YhKQVsnjkLIyU6rfzh/iPkMxbLPXmnMwPWh9htc3B/I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-1a3k85YtyJrID7RwECMfebP4OyyVaRg5QcAYkVflFPo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-tQUty5+qZy2E/ng4JWF0xY5uQrFiWEKse5wYz7ELj+s="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-5bzb2R7CcSjCeZIQ0DCoep6bFWpYZogPl55HCps2cAU="; # aarch64-darwin
      };
    };
  };
}
