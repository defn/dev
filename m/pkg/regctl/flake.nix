{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regctl"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regctl-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-bOqTeXl+IM7PWeRlaidxkoWSzAzsWMlnzc/aS1qbOK4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-L8DiP9/dEhNYD8n8sT0iY/HfvEoRGQsTbbExr9Ah3nk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-QH7AeVJi/Ehn09yCVDq1qWvO6VBwquAFV6uPQyX5DDQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-QTr9nUPdjknzYTnOgfKG32C2id3aPngG82V7zLOWQL8="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regctl
    '';
  };
}
