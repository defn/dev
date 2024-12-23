{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-workerd"; };

    url_template = input: "https://github.com/cloudflare/workerd/releases/download/v${input.vendor}/workerd-${input.os}-${input.arch}.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      fname="$(echo $src | sed 's#.gz$##')"
      if ! test -f $fname; then
        zcat $src > workerd
        fname=workerd
      fi
      install -m 0755 $fname $out/bin/workerd
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "64";
        sha256 = "sha256-555ckNP36bsBUho6WORmhc959paZ9cE+LEWsW+9Dw8A="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-mtRvn+EgPHZ+yoOR+B10ovm1j1ols38Qh0j8tX/8Nik="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "64";
        sha256 = "sha256-XTkyq1129/DeAWi/Ior/LAZZO+gSPo791wOz/9qgRqQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ZPoGychAW5JjVr5JA5rz6iIMnX5XxWnX1xHQIdSVYGw="; # aarch64-darwin
      };
    };
  };
}
