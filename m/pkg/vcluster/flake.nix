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
        sha256 = "sha256-D6vbxeVFm9Lo6oaR9bH1ViCCRUGwrQfcho8NmNYo33I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-xj3bW+XZ7GSbO6uKbVAxYgfx/rpks5fRJwjs0VJFVSo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-hQ15vmIkaFLTU51afgMNp013Xho21nuPcNFszlxPXpI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-oAlpH3qrNbnYA4djzDRv6UrPc+Vc3VwRnROk4neN6sY="; # aarch64-darwin
      };
    };
  };
}
