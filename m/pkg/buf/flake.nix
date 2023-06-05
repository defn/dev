{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-HbUTGOSfEglcl4Zsm12Tnf7DGLUDYruoo6lUXEz/RWs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-JXcQdqQHRIQNzyO3/JW1DIRodJLlcw++oTMNM2k/Vc8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-fBwMLQRc467h2zRQAUp9i5eKyuOKZD2TGSM8gcDwZd8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-6BWQHawjhOmmyj9ATpie0bSBXhunuYaSavi9FRxopxA="; # aarch64-darwin
      };
    };
  };
}
