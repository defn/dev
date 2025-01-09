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
        sha256 = "sha256-6SlHGh0obp+2vT2FBj+/TGeOfd96SiyWBoJdq315NB8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-nTl1XMg/vMGIdVutcUi2Pmy1RSFUBdbFvi7Z16EsEuo="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macOS";
        arch = "x86_64";
        sha256 = "sha256-PHlJPO7j/vWBMlF+ob8lmKAUR0RdAl7UFs2ljsZnWFo="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macOS";
        arch = "arm64";
        sha256 = "sha256-yDPPYhq9Wr2tU9Gyt44uJp8lztPXMXigcMoI05CVIgs="; # aarch64-darwin
      };
    };
  };
}
