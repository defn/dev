{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
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
        sha256 = "sha256-uf6DYwYE3B/sr30c/doStYHrlgHqxJMIyXbc+OcevW4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-aUAzHUt8hS2pWVE2gLIkmgdUSEcRoUq56OPBBC9GN0k="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-GKI/2fxaG+IRaVfspt3d+MFbDrFuOxFW5D88mlFvWnQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-MkQQ41GGvCpLXErJhLXBpZkED7t+fH44s1Qn1V0U9mo="; # aarch64-darwin
      };
    };
  };
}
