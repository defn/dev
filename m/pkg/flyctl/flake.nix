{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.7?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-52qVJpDq3QZ7ZyC6rjzwUDUKL8YIiiC8NFeAZng6ywA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-s6RnQs7fQINe6/xteOgMt8QYq8l7pSXYDrQmHxTlk10="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-4uWqwNtCzEA6HER+dQkrOzrb9aUxqIxDw3ggyqgSMv8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-96bpTxZVJ1YKdkLPBgbBoQPRMgJZemYmIwaVp0bKFaU="; # aarch64-darwin
      };
    };
  };
}
