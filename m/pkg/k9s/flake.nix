{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-PcgjilVK0gUbkZMfnaFUGI4iKpoazMRBDXqHplSqs04="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-Kv00s842gHyX1nuEB1/HbAe1726Jx729cMDOLVFEqi4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-E3KWfzA+Qk1mRgfbZEcilJsIs/jP7t0mvjk2dZr5vLs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-Qp4Qixc79Gnvu8kJz9A02fV4Gow7MpQj/x8W6MAc0aY="; # aarch64-darwin
      };
    };
  };
}
