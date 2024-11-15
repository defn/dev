{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
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
        sha256 = "sha256-G9Af9e1IG3AHoOLlmqBHktgh+7oXJ4uwgMnbQ5kDids="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-HVSc5QVA75QiM2A1xFwhU7b96cvlqf5yBl8ziVLvJEc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-lET/cd32dP5h70cIydeYW/PfrxNScmB2wG5/V7yKwBg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-moJE/5qjgh6Yxv9N8BrTDaL2PMeRVvOnTPAyKHWs9pM="; # aarch64-darwin
      };
    };
  };
}
