{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-linkerd"; };

    url_template = input: "https://github.com/linkerd/linkerd2/releases/download/${input.edition}-${input.vendor}/linkerd2-cli-${input.edition}-${input.vendor}-${input.os}${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/linkerd
    '';


    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "-amd64";
        sha256 = "sha256-vRpFv03YXJslY4BTm3v7LNN6aLBg2B3enkUL9hY5oaQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-A7xCbASfwT4z0+M9zQRtMNJMfHUHVmZtL3uF4PKgvtU="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-8hyvCq9WTYj5WAjmH3aiPX8nMMn2UMqKTY4Gkj8q34c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-1SGIu2Y4vd1kmE9NvV7TRe+nVvn39l93xtpRJrKVxrw="; # aarch64-darwin
      };
    };
  };
}
