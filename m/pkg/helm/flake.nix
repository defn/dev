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
        sha256 = "sha256-E4Z2NRSD5h0S363nDabAPUcbvcrITqreteHQb6EUok8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-0SoOc6fb/32J0T4Mbrc/UJX3LXD66jBTGUHTIGeJBNI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-1EqjJLprIDTh+e7DS4DsOGpeLIij20f3J2s7WYHr0qE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-/aEMaU8ukm2LQZXBIAHoNBO1mPt6goyLZ1GuSjVeDKY="; # aarch64-darwin
      };
    };
  };
}
