{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/temporalio/cli/releases/download/v${input.vendor}/temporal_cli_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 temporal $out/bin/temporal
    '';

    downloads = {
      options = pkg: { };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-moyFXxmIDhgk3sXR409Imh+CH42yrJg9IMzUPQZcfxw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-i7+hm0k77vwvc3CZ6VavcjrS6HoBQeFnJPaQgPNw6iA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-7+3Uahb2RaT+vXZNJEE3jweUFfSpxFgHBRbL7X4JG8w="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-p71fQIR8NOML9YD3IVWVS0c1Bh61vCZ+duPn9X7HWmw="; # aarch64-darwin
      };
    };
  };
}
