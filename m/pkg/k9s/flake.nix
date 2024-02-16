{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-k9s"; };

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-B1pYhkLjXNaDlLitDfR0QjZQlF74p4Z2e3+84KR2T+o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-vO0HDdC04CkHClFbYropRCSgxvBBbk+sJLO8WHRVQwU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-8nh2M8OQatqeS6bvm5X6FKmTXs2pzUOWWT9LSaK1XBE="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-oiBxFve/pB+91m8Z22MbSxWcOK8XbgDWVW8e5wRZ364="; # aarch64-darwin
      };
    };
  };
}
