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
        sha256 = "sha256-cf3ok1vSxDEZ6an2K/BUDDF5k4e1WaqaCNk6EjrSsXg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-C79auBCbv2o2aq9idNk59wZemsoljtyXZ2p4A29MElI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-WhCCjI8sVFfnwt6TChtY40zadAaCBvHQDq/4NIiRUpI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-TOnRnSO5f+chiriV6BSXeNT38GIJcu2nN5cHYKoP5rA="; # aarch64-darwin
      };
    };
  };
}
