{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
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
        sha256 = "sha256-thIhEhpRJwhM07T8vYKdtqW0OE0zQADX4goMOJIZRdY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-NdgTGlCpHQ5yW7Pp7gQYdT1FxxVToa4urRUeR3ZT6xA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-NDQ7RRMkIR2B1/OdaYojTievgRxIPvP6QAiwsxN+L/I="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-69KX6Hz2rCyEF2KcmZ6a8dLoypJ6dDy2hMt1Wx0n1ds="; # aarch64-darwin
      };
    };
  };
}
