{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-mMNjVk0Ar9DMMIjo+DDyoO618odVs9jEjfiYZjdKHtA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-jEoHdyGLJmp7l3OUqvDpzvMO0t9udC1oPlI9dVCNbv4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-4gfgCbkxFisDg7RjwzOieSNVIA6R288WfJfBUOn1/ts="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-RlltbS2apUXrdPQGhIWPrAhB3zc8p2CvElnTSTFh2Mk="; # aarch64-darwin
      };
    };
  };
}
