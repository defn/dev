{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
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
        sha256 = "sha256-KJ6znfyxx9m0l22wORVTR+gwX+SEEjouhcLUj7p1EmQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-3h9nR1Wf3mjKZaMZA6tfOwzOc2WijPmXBou72vkgafc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NAbviHzR4n320/VU4ET/a2vPKse3w8A5NwNVu0+WAAA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-gdTV+nATI4lIFbdyvF70TFZsdrWhJClrDFPxrCfCvZY="; # aarch64-darwin
      };
    };
  };
}
