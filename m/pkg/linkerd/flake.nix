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
        sha256 = "sha256-fiA5mcMjEhlKuPmuZEVswkLSVORQZl7tcK/upAhydD8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "-arm64";
        sha256 = "sha256-ViBTrx+gcttyKAC0eR3H1ONDXbWI+Ob3cUUCYYjd+Yk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "";
        sha256 = "sha256-DC7E5oO9vIYvkAgt2/drOc8jAd1ePX6h5I6WGvGvF8U="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "-arm64";
        sha256 = "sha256-bxjW+kFqV7Y3CdgtqafsRiGZIJz+cB1siQDjhSXyuF8="; # aarch64-darwin
      };
    };
  };
}
