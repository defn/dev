{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/nabeken/go-github-apps/releases/download/v${input.vendor}/go-github-apps_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 go-github-apps $out/bin/go-github-apps
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-XIu5odEQDU+g+DZ6oKd4bAFOPxD9uC/IlsbMMiF2pz4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-o+x9ptBjvGFR/t1qstMXGYjjHWUkJDAkam6VRbP8MSM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-81CcOUo6g4jnDXpNP8DQ2AYtETeOi6sPR+hTXVXk/38="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-JNI1P2pbQ3C5nelKiX/u2u9MD5XOTPWgt4YyJ065GB8="; # aarch64-darwin
      };
    };
  };
}
