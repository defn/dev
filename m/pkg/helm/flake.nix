{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-helm"; };

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-PJDyThgPjCB7ihjl7ILLD6SYWKegqG5O1SqYOYaB4As="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-heFXPnb6YK8Uun6ex12yEptohCA76GaJP6Cz9+QczV4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-TV0BqUx9awfnFpDcGYi/MiloAoTIf0JC0oxvHMmWU74="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-3/eUFStit8Gp/2FdUQ+GV7zXo3J8Zo4NnUlV9w1fdXM="; # aarch64-darwin
      };
    };
  };
}
