{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/opentofu/opentofu/releases/download/v${input.vendor}/tofu_${input.vendor}_${input.os}_${input.arch}.zip";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      unzip $src
      install -m 0755 tofu $out/bin/tofu
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
        buildInputs = with pkg.ctx.pkgs; [ unzip ];
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-JVBVyK5XYESOE+bvn/e7zKvrTlZi+qdwygQtKYjyGhg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-IWYpwN/h1DcCGMEdzbrm8IziweRmfU/ZrMZnYTUWqsM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-3rSsrISLzBy9IyZx3K2oJHXmETw8pAwHtkGrN8lQqy4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-hwuVZ9PjMHK9q3kcrmsWceqgfDpa27DLCeeH5zxs9vw="; # aarch64-darwin
      };
    };
  };
}
