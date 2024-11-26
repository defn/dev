{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-bazelisk"; };

    url_template = input: "https://github.com/bazelbuild/bazelisk/releases/download/v${input.vendor}/bazelisk-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/bazelisk
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Cu4JxxgosAEnUMubaJzjV12o4jDyZb+Nbc1FTu5uqEI="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Kg5dOX9929rB3v9BZ8doHZ0dAlxd+pecKzfwkfAy0Bo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-gMLEiT85e7KhLUjGlcW9B6MoZg3Ih/gk0Fzoo7y20nA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-H7Fqf89bAU6KQXmjWIp56blT7Wny8ithKydwFQSF6Nk="; # aarch64-darwin
      };
    };
  };
}
