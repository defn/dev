{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${input.vendor}/kustomize_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kustomize $out/bin/kustomize
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-iDRlQyBriJ+Sh8C5LHBwgEDs1arVTdMwGcTWV5zSTeg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-VWb3ut7OWnLUIHXY3/pilqIolm3WrCOQ3nr7uWdcOqo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-t6unSdp10z5v6kmlCYdH03mrxFWD/1zRbiNWEno5ZUk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-9qXzz/1FusWFoMgLXthVwrctkyodbo58h6rjvk66V1A="; # aarch64-darwin
      };
    };
  };
}
