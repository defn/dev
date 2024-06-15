{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regbot"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regbot-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-d3hPOL5zLcTdMR4AShSPzQe1w61gtKYFdWFEKdL51dg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-oGqN8aihnmawPkar8TAtFLhZv0hdk1Vv8pfbGsu0Gwc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-OPPET/EKzd9YZBcMNi3rvS8OLcsQRoad4PH/snT9owI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-429M2P7bZmggjXx3U9/dLEwMKzVoljGt56V4lqDE9ss="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regbot
    '';
  };
}
