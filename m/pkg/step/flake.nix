{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/smallstep/cli/releases/download/v${input.vendor}/step_${input.os}_${input.vendor}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/step $out/bin/step
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-coxhlQfVsot4jdpVj2DsqHnKVjeAoMiL8bv3uoiwJSI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-kkI33XrzpcjfU0xoBpTW5dscgAJcqR19sR+eyQX4pjM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-n4LiMynYalJpwDJVdN6GibDCMeFtX2FDE3mcI7m+pi4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-xvcPu5S9vw7brqcyOPUTikjNvlpDVL4olLdNvFq0Kvc="; # aarch64-darwin
      };
    };
  };
}
