{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regsync"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regsync-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-1RAKw/d1vyiimcXgnXr+JipLio49+Km5u7+zg78ITsQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-WdsZHqlSkeaU+00DgiYt+9MVjifjOfJ27kduck8Qzzo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-CGi4ElBQL3cyn4yX3UCaSAWAaXXAteKtWnSw3uRr68U="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-nCKqvPGkKbNKVsWLTGT1K+nlW3t1iuPgTD9iqfX4Eo0="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regsync
    '';
  };
}
