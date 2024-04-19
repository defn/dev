{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-wireproxy"; };

    url_template = input: "https://github.com/pufferffish/wireproxy/releases/download/v${input.vendor}/wireproxy_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 wireproxy $out/bin/wireproxy
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-vuogFqNOJHYtU51/9ycYirZwnlgHLXppCFxdTwrmZdw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-X9+RdWfmkDaarfw0Ijl2M4SPdY9ybeITLeGH49T+AhM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-0q3aMACfyGGbehJlB8Q+Y7QKf6lBpXFjhj72tOa46Tw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-cEQ7sYxjE4iOdaEQXiBs4QCnJi60vOA59gBP0oVrFrM="; # aarch64-darwin
      };
    };
  };
}
