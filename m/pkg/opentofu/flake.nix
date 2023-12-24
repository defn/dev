{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
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
        sha256 = "sha256-yBD6ZNcUffQnJoE2DvW8mjZuV0v9q9a4ixjiw2w7Gu4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-wExSxa/UoEF/z5x60Nf/BXSJg1Sa6DDuRRunfeC9d2w="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-kc8tVGxH+MXG+C+MD4DyOBKiWKu8qnzBPJmlIa8S/cs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-/nCyTnCG0wnOWxa2PsMtPpMuGBtxMCjSQA+nozO3G6E="; # aarch64-darwin
      };
    };
  };
}
