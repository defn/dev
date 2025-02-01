{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/int128/kubelogin/releases/download/v${input.vendor}/kubelogin_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 kubelogin $out/bin/kubectl-oidc_login
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-g805KwtTy/QzXj/bvvbKHrJoMfs3Np6XWRaZVOqPe3s="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-mWtjNrzagHSTsT87SCOYHKTzREg1glv5nrTAx0l5Q2Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-YRJI2s83Wqqp0sOpwRWE1mEj4jd8iEuEmdxLuh+y8Ms="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-6+ZNqtw+Llv+1JYzJW6gQWLEial0ybDnuX6H6LUEz8E="; # aarch64-darwin
      };
    };
  };
}
