{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vcluster"; };

    url_template = input: "https://github.com/kubernetes/minikube/releases/download/v${input.vendor}/minikube-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/minikube
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Gsu24DWCZKOs1eHcCB3o0xxpfVtDCb4hy6VYfNWeq7M="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-d8qYcigZ4unZSSX2YvNIw9QcGDHDzTp3cyCT1/UJ8XI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-jKSyzOYgjxArhR0OqCksEyToNYt6wgjdEHnkGvVY3vg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-9b84YDsBzD64jyHVVQBo/VkkhsCMDzJyruVE4LwuTmQ="; # aarch64-darwin
      };
    };
  };
}
