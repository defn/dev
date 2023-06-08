{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/earthly/earthly/releases/download/v${input.vendor}/earthly-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/earthly
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-5vSjjDZ82YS8gEr81n1btpTgW5SkYUIyyg+F1r/Zxjs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-o07YbNVsW+sOR0GvG6xoicfPZi9QljwksFh/IulYZHM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-IWkV3nEsD34D5bdhijz6iRQypbtOzxNHOyKOShqJerA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-z5M86KmfoVpRusSScWoV8Z6wVwKEC1BK+GMnst6V8RQ="; # aarch64-darwin
      };
    };
  };
}
