{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.13?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/terraform-docs/terraform-docs/releases/download/v${input.vendor}/terraform-docs-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 terraform-docs $out/bin/terraform-docs
    '';

    downloads = {
      options = pkg: { };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-jkNtDETbScLM2V3u3gXD3roySzSidL4GzZupzfZE55U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-QYnE0LQY5bzGQoNrf3PoDV1Ngrda2nOnt4+SNYjV92U="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hGwKQBFvdIqpALuau3BLNOQGV9n5rMgHq5S2Y1XA6y4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-I9g+sDYVSj3hoq+C5vdysGvW3wg5ggjUPIylb2nQRWw="; # aarch64-darwin
      };
    };
  };
}
