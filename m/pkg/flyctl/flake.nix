{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-flyctl"; };

    url_template = input: "https://github.com/superfly/flyctl/releases/download/v${input.vendor}/flyctl_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 flyctl $out/bin/flyctl
      ln -nfs $out/bin/flyctl $out/bin/fly
    '';

    downloads = {
      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-1zOxlmE/493zhZ27Z1l9b3eH1KyGF3t6RuG25yikhVA="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-BgWaW6pweAkwtT6zrUscRtnDPLD5WFHu31S5HrbG65Q="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-ASFHW8LqAVBstgFhwt81TyoKtxzUhrxbX5kdV9x7OQc="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-8RNVUWTHdhz0HDkRZVp8ZvhcijwBiJOb3MJ91/Sz1a0="; # aarch64-darwin
      };
    };
  };
}
