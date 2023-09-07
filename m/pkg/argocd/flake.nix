{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/argoproj/argo-cd/releases/download/v${input.vendor}/argocd-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/argocd
      chmod -R g-s $out/.
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-jTzP9L24sXbHAybgH/EY7jSQyYkSgN3jcDVsSyEZYsg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-LVDbAvlNjXJ9wfZeXreuUkDv5hx4XH15RTEFSd4EXao="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-eF9jzyWOm2BcUySLP+Fh5KDJ2dxudXs0CqKBIB5vPCw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Wk86bHM89Shex4L6w3NEtTRBd5WL15svrtFDD5Ot4D0="; # aarch64-darwin
      };
    };
  };
}
