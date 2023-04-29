{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
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
        sha256 = "sha256-yi1dQNTN+5o6YgXdgDtbyN7wC9LxPlUmwSfptmeXSok="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-n1jnB9y+mjt4hcTiTvV+37l5RJDXJwWzOpP6HzVyzOQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-nQKd83ZktQ5CdEKmAOTgZfp1/XTayZbIMaxoNZZUssQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Jn5NULaOiFS5zERRfamrL0few5eH/tn366QggNYax/g="; # aarch64-darwin
      };
    };
  };
}
