{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = ./.;

    url_template = input: "https://github.com/dagger/dagger/releases/download/v${input.vendor}/dagger_v${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dagger $out/bin/dagger
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-gAg4BOG8TClo283nY76cbV8sEupgJk8bjKmDpjjdTYE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-pYwPWeMI1zLN9kDNbBNkFyt3xRm0gWKFJJFPDGaUyv8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-zT7U9Mvsci1yGzpfkT5CGYrhrb23o7xbcj+UQy8Obbo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-V4yCUzm4lMjEnV7JMtQ2Lg0Ra4UzEq2j/TN6R1xTwqk="; # aarch64-darwin
      };
    };
  };
}
