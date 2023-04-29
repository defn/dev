{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/k3d-io/k3d/releases/download/v${input.vendor}/k3d-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/k3d
    '';

    downloads = {
      options = pkg: { dontUnpack = true; };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-X9ZZdmjnsJwSbt26+nn44MM2lfKXTjX4yUY+80YvMRM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-fU2Scu5/opTs2BfjJWb8z1FEidXZVW8MxHHez17O+hU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-bynHaOeJppEAUfCOcRIGkvgs6D11lYLPgfh3XFuNE/c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-9RSnapLxgrM5Yz8MSaJ3W4WV0gNx7ZJZTYXoNSO3iXQ="; # aarch64-darwin
      };
    };
  };
}
