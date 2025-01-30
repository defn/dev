{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-just"; };

    url_template = input: "https://github.com/casey/just/releases/download/${input.vendor}/just-${input.vendor}-${input.arch}-${input.os}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "unknown-linux-musl";
        arch = "x86_64";
        sha256 = "sha256-HFP6hajAIc57GYFOGl4dwKoQwEvdynUZb3q222Ew0s0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "unknown-linux-musl";
        arch = "aarch64";
        sha256 = "sha256-8bms20N0mDU5x2XWA3Q1CTJSffgHsll14Fq7FSyQIec="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "apple-darwin";
        arch = "x86_64";
        sha256 = "sha256-bHhqxWRuZDzCHk19L12hK2kKVMMtNTByJNs0h5NErUw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "apple-darwin";
        arch = "aarch64";
        sha256 = "sha256-qx4fyVvDzRHunswsdkq71g9tT5na0FvngnblSH6VkFE="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 just $out/bin/just
    '';
  };
}
