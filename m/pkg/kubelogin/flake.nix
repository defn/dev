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
        sha256 = "sha256-hN2TKJYq2WvLN/AjkedDUcKziN9fPu+78jhch+X+y8U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-VwDJ3XPnOPV1mfTZ6f6PGPZNSIRGff4VzB8OPEgFBZY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-/+qy94nYEUfM+U6sS/fXkjjnyF+gcrDgA2Ml23VI/5k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-0Y+bpjXNf7KU3yg113La7sNtrLeA4Z0dqbRbj8ejJaE="; # aarch64-darwin
      };
    };
  };
}
