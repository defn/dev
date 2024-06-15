{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
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
        sha256 = "sha256-M8Mb9f66KStZuNq+VUfLUqtWVSHuVhm1LrS9S/ImzqM="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-C2MVIGhD3ilaoK3LFyr0QYLNYLqPw0eSBpyZPRJiSik="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-TfWd2TC+9LD7vIVYAB3T57zsv6I/K0sAjXUoXnOlkGo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-kWpRzI4MSIEaG0Wc+tmCAbqeC5DldB2KiJvtcYFp8X0="; # aarch64-darwin
      };
    };
  };
}
