{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://dl.k8s.io/release/v${input.vendor}/bin/${input.os}/${input.arch}/kubectl";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/kubectl
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-gOcESEVfPRnDy0m9b/b8kTZ39PJA02j6K58NQAyM0W4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-KM9fZmywwRqKKz5a5L+T5Wt0q2BRcgxyuyMYh7/Bp8Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-T8lKYgZdJfgEgnLaCW4cXjvSJnZ1L7OiRTfkrWKjM4I="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ZRnicwF1kL2LGT1lCvemdlcI8f7TXcvK/6/l8zhy37Q="; # aarch64-darwin
      };
    };
  };
}
