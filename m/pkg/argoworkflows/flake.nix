{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/argoproj/argo-workflows/releases/download/v${input.vendor}/argo-${input.os}-${input.arch}.gz";

    installPhase = pkg: ''
      cat $src | gunzip > argo
      install -m 0755 -d $out $out/bin
      install -m 0755 argo $out/bin/argo
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-KRPUFCHm5xvZJu/4fsS8Oi60h4uhuSBT5P85VbVRxrc="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-sulAnR1J7h11p3e5oVZRc+qOEgCvPWIIKdOTiPvMjdQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-9hwG8BJPjckYoDlIL5ISru2Sdrugfa5r2B4UjLkUUqI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-fvVC8lA504xiUNAs61bZUCgmEmJAF2oP4kILELplxXM="; # aarch64-darwin
      };
    };
  };
}
