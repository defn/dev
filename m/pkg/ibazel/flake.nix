{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bazelbuild/bazel-watcher/releases/download/v${input.vendor}/ibazel_${input.os}_${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/ibazel
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-hHcbx9qdWA1c5gGHmfWS1HZ6WUCwZeTFEsUeWo/oC6I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-1QziA9hZp4uqAbWej06to0OxH256PocRnsdYKAvJ11Y="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-xtKMbXA5jC8/yT17F54NLy7IXgqbqOeTly3tM6YXZp4="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-cO/ncx95eNIGpJX77Kn34NsyDquuEjfFDa1QIJTxvw8="; # aarch64-darwin
      };
    };
  };
}
