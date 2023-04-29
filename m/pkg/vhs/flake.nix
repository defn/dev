{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/charmbracelet/vhs/releases/download/v${input.vendor}/vhs_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 vhs $out/bin/vhs
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-CzcO6xCZzqUt7jBhezEF3g18gHQzx7YkiZfotEz6UsY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-0v3tEs+Ngv5D3yNp1xEn7AeYL7VLSY7ahcBv9BxK0Pc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-/iTE7oN1ugUzdIRuSslKuMkAZX9qYXsd/0X4YjuyKTE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-W5T0J7pIwFJceSD/Txedfy3DyjU7biHXEJtekpFmqSA="; # aarch64-darwin
      };
    };
  };
}
