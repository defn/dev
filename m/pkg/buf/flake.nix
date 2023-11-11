{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-DkKUxojl7jHaqeAf3PKJRpdPpMATXFngXcRpR+UcrB0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-anIRwxQiBUWPMxtv2nq9C9eHSa8Ba+swFkeqZnCMcag="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-tzkTCSBMQhuD1mlr/Vgfa50SvdRMJL20Cgbad8Wj5Xc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-+bhitEVSDfj5s5MS8ey9zCOwX57cEOoDsdN2p+tNNRE="; # aarch64-darwin
      };
    };
  };
}
