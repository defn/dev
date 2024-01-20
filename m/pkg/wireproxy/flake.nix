{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-wireproxy"; };

    url_template = input: "https://github.com/pufferffish/wireproxy/releases/download/v${input.vendor}/wireproxy_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 wireproxy $out/bin/wireproxy
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-7KLtpC+i1Pcd6AVfeQZvzjhm0iyPOAYO6Yl4NB/SoHg="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-9x6MSIekLP8Fj0bycMwsFCui/bS3FP1sZeRKDtCeJDM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hAJDiL+9t5qNCEdnMl70uPJcZVH1Ch+b6yQJ5zBBZE8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ppkKxmv7v+rveH3/OewIYQzKfHfTN0e1p2WD5/eRbyw="; # aarch64-darwin
      };
    };
  };
}
