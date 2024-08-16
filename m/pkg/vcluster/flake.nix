{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vcluster"; };

    url_template = input: "https://github.com/loft-sh/vcluster/releases/download/v${input.vendor}/vcluster-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/vcluster
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
        sha256 = "sha256-Qd4KOt8mSUbvnRrlMEajao1ykLtO6d5mpKvnsnvsf/c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-2oGIVYBGAJpG5IC0FbYRBOC+Pe1MRLqdqqtAfuNyMIE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-CvZROe7GgEyONAZnaxjUIG/pHcwmPzqN1yZOR8u+jTA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-nJ/Z3BV8fdp2Kgb4p08YvJP/FLjR2HujQe5R8N/FEzg="; # aarch64-darwin
      };
    };
  };
}
