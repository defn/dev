{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-terraformdocs"; };

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
        sha256 = "sha256-fM94ykR+FV6/j/CjkIJig+3tZR1VuOaMxTSZj49frCw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-wTG75JPNl+5nqbUjJkzGu0uyWqUG1lJJz7WRPF9k53I="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-K0cX6XmUG/r5IlxmRj/oliwzcT1fFcKqdkxV19agtok="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-kGVPhDbuKPmiRdm2r4i6MFsJxs13NYi5Niwp922tFzI="; # aarch64-darwin
      };
    };
  };
}
