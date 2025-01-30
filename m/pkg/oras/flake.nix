{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-oras"; };

    url_template = input: "https://github.com/oras-project/oras/releases/download/v${input.vendor}/oras_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 oras $out/bin/oras
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-v/lwNGRw5e+Ijp8sC/f47kcoP1pFIH1uegN9ofsOrg0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-7dcZXLuLpWwp7eQT7voQyAJiAdYzJgF80xWEG0BjqlY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-6VPDxVgKMXujCHHud/OaN+W8sDDt8BxemoPr3c7Hz4o="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-/Kwira8c/nhUc4hZ0PRwXRzXWiPtrvXuLpq6Zs//IxU="; # aarch64-darwin
      };
    };
  };
}
