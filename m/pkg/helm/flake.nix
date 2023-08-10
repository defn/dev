{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
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
        sha256 = "sha256-GyMTzRmNReqwDMN8OPaxygqUi6J5wp4yK99CbUBhKbU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ee8Gk1+0fkMsDJG979FA5bVD7EY3YAfKFKUuXtMCMIg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-G9u+7FoS3Qwc1O/YlIoVbTPh4vURQOKlHh5eexG4HUc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-JAsKfanK4ggADv89P7leD6H0kD2VvmLD8nb3YwsS2uE="; # aarch64-darwin
      };
    };
  };
}
