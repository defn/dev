{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-kubevirt"; };

    url_template = input: "https://github.com/kubevirt/kubevirt/releases/download/v${input.vendor}/virtctl-v${input.vendor}-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/virtctl
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-98qcYu4z/42ihTcIAjMve4IfFBYJJK75oANJHVAKSPM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-98qcYu4z/42ihTcIAjMve4IfFBYJJK75oANJHVAKSPM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Bck34DjORy0XLE4QS5sEUEQXrx+DzCXjmWrxYXfheYQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Bck34DjORy0XLE4QS5sEUEQXrx+DzCXjmWrxYXfheYQ="; # aarch64-darwin
      };
    };
  };
}
