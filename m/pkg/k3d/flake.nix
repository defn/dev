{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
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
        sha256 = "sha256-SEkCfcXoNbzOSQcK8/Tu6q2oHZa85JqLiZBIMqDDwsA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-SjdA+yvGH9oyskN8JwpffcMhreXpy22TK0uXOXU4BC0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-XTtndus0nqs4KSKc6Mh/nCeQk7AnLMUimB4QG0DE1sQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-iRFhzRj1UFyNPv8INEwAynb4B9+z0BnRGfwQE/42Fu8="; # aarch64-darwin
      };
    };
  };
}
