{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-hubble"; };

    url_template = input: "https://github.com/cilium/hubble/releases/download/v${input.vendor}/hubble-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 hubble $out/bin/hubble
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-M9BsFEqzmzlm2BX5vyR0wzH8MrHuUtHC9VnwRD3N/Jo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-HEotKs7BTT0dUuUbFyNgjX39VNx31IO+ced3TJ+HDsg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-vw1zhiYD691+3BUjRIPjj2R+9lJ+7wRvrDTbjaBj5Bw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-B0eYF1HtLuxAaR+R5CPxFDXDvDKOqhPd3dFwPwb3DwE="; # aarch64-darwin
      };
    };
  };
}
