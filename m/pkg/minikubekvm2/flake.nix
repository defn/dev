{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vcluster"; };

    url_template = input: "https://github.com/kubernetes/minikube/releases/download/v${input.vendor}/docker-machine-driver-kvm2-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/docker-machine-driver-kvm2
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-g9MXXqxxCxV3IJ3d5VkskHE2W7KBxvyXzlvUgQb8Gaw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-VDmis9HsfEk9P5i1VTh5AG4xIJ0sBnSkXhRNaBlwHOU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-g9MXXqxxCxV3IJ3d5VkskHE2W7KBxvyXzlvUgQb8Gaw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-VDmis9HsfEk9P5i1VTh5AG4xIJ0sBnSkXhRNaBlwHOU="; # aarch64-darwin
      };
    };
  };
}
