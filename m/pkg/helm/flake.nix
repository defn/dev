{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
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
        sha256 = "sha256-Vajm3Oh6HlLGHgznqJv4WzhyW6Po3rUdSgit6KLHCy0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-9WVKrtY6DacoUnduHT+FGy6pUpy1aWM3ICcDwuHtIyE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-l3wvqkmZOqi6oscn+PNaNXV21ieNTYYYpaAQpWrS2+4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-APAMZhZboNzZ79vvZqVQj7T+RCWZHA5ZngcQ+P96oC4="; # aarch64-darwin
      };
    };
  };
}
