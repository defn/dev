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
        sha256 = "sha256-bPPPqmuBMF67yDzxEZ+mDAefbNl1apuvQWkQO4Ee+Gs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-5ozTddB7ljwkVrQyZUmaVD7KgzI5HYD6SCBX8pXb2fI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-d2keCoCRJ1CEm/MDhAsgXSY6KrJg9lUDykp+7RhjZaA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-P4h+7Z3Nh2CN9cqi+2EaGBcW9RbeUYPAcKqDaHqcDHo="; # aarch64-darwin
      };
    };
  };
}
