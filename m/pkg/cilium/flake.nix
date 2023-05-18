{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/cilium/cilium-cli/releases/download/v${input.vendor}/cilium-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cilium $out/bin/cilium
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-YT/8HMYs41tRn+tvw50csrRmNVEdNl2w2l30mPxrwAE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Nt+UNEnd4+7PHkXMQqJE71FjrIn2FHkaBlfPA/+SJz8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hBU+n+R+x2RitG4ncCRkA/JoZ1Uzi3WgkFw08ta4kkw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-yqZX2Kex/PvOrSLZ1MUesAiaK5Wg7l/Xcxom7h/kHaQ="; # aarch64-darwin
      };
    };
  };
}
