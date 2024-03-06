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
        sha256 = "sha256-Q1g0Y9MSgj/YMpuZIqj57tMUlOWMCEd4MuvKm6xCF+M="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-DwHiW3Nbtqr78012wIQ7Io/Rb5/w0tfwODUWrN8ta2Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-5d9PLWSU+ce1zDJKDUm8OxjSYl71BAl1WMHS3BMTTaM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-0Ch5HYzm8mYiSyNZtz9vAM1pbPGyL6WKJnVwgGWCKus="; # aarch64-darwin
      };
    };
  };
}
