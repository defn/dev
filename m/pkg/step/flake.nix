{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-step"; };

    url_template = input: "https://github.com/smallstep/cli/releases/download/v${input.vendor}/step_${input.os}_${input.vendor}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/step $out/bin/step
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-fMVxdE6tCYwI5CrQnk/m1sFXUZx7USTEhyz+hCRfvR4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-fTG4BVdm5jRZmcQM5DinOXcnmtM9MBfjtjxTgp2dOpo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-ikiSVcfONbi8tnt9YB0100h8YAWMlej6SWbQFeM1SmU="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-4Ivzh8egmuFjmn+NMTqbgvfkRudhUpSBE+LR7GConFw="; # aarch64-darwin
      };
    };
  };
}
