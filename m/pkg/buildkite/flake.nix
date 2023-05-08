{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/buildkite/agent/releases/download/v${input.vendor}/buildkite-agent-${input.os}-${input.arch}-${input.vendor}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buildkite-agent $out/bin/buildkite-agent
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-VvzPDRjvhBnEzlcL9NFfR8K2Mxz39Q4NRbJwTQFonGs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-avqxKG7d5CJm6mZ3P6xNTYBJ4vrkGgKo6oZOf9pMlfY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-n/f1GFvcF9nISymG1QfRmKroyz5C4hF9eWHMhO3qC7Q="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-n/f1GFvcF9nISymG1QfRmKroyz5C4hF9eWHMhO3qC7Q="; # aarch64-darwin
      };
    };
  };
}
