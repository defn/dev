{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-kn"; };

    url_template = input: "https://github.com/knative/client/releases/download/knative-v${input.vendor}/kn-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kn
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
        sha256 = "sha256-GTOJ51fFarz/DTSCo58gX4/5J1dFjN8R6GXL97LQLmc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-BUmLpeGs+jktwpZD7BhOBirjCwdcgOk6KfsjmVEMXAc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-XOCUIY11PjRTTK81k48XtOoChtDCJBPSBzwjmQqXvXY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-wMGXvkw6wnS3m5Vm24wHr23b62jXoxNPnSZWx/6eYoo="; # aarch64-darwin
      };
    };
  };
}
