{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/vmware-tanzu/velero/releases/download/v${input.vendor}/velero-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */velero $out/bin/velero
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-S82CguzcL965T3wE32fcEIWxuTUnyrqZGXNmhxyl384="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-CGYWZTk8Qwaxr62CTtEZmHxstdfNIqJD/hYSfUFBxRA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-qytEiwjaLhRR3sAMGosrjcZhqzss3hTm6oLWb8ulRKE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-qytEiwjaLhRR3sAMGosrjcZhqzss3hTm6oLWb8ulRKE="; # aarch64-darwin
      };
    };
  };
}
