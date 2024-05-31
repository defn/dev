{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cilium"; };

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
        sha256 = "sha256-xsOBBEAlFnot7JQ9+uJoh8+kreBGL0Y0Zvz4LaXfhEY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-NBdYS9Y/NmF7BVbg8yfUWtNapGK0890pB2A/XJBA+4A="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-fLtPYu7TiBmyA0j6YycbzF/RJLurmH04c1s7O5Ua94k="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-x/aR+3sE2GKP8TBgI8pcrFasShvjQbfoMZp8eLLuqOQ="; # aarch64-darwin
      };
    };
  };
}
