{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-GnB09Y73GQ90zm212wtw41WmVeIBPE1dsjF+Y/qePeo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-UFSNT+3vnY0B0e1aLdXISScdEBcSdBfcTH72d3rmj34="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-9Ie12BMr0gkTeCWKMCnjPuEPcVdbIWfN/q9tAUTSCTg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-6C4EM1ibG1FwgH1v7HW67bpAYgRYUQu9MM250iRkFf4="; # aarch64-darwin
      };
    };
  };
}
