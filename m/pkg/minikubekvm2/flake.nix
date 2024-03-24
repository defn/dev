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
        sha256 = "sha256-DMR6XFCPVmq0JMSWMj96PlBK+WpAAQJRhZ6K/c7DG2k="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-2EFRKhabC+Y82uD3DcxkkagvjP1Axnus7BQ8gWP1bo4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-DMR6XFCPVmq0JMSWMj96PlBK+WpAAQJRhZ6K/c7DG2k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-2EFRKhabC+Y82uD3DcxkkagvjP1Axnus7BQ8gWP1bo4="; # aarch64-darwin
      };
    };
  };
}
