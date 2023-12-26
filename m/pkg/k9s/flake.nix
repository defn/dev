{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-k9s"; };

    url_template = input: "https://github.com/derailed/k9s/releases/download/v${input.vendor}/k9s_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 k9s $out/bin/k9s
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "amd64";
        sha256 = "sha256-/ajNVC0Y8leLjO+QRH8tBZv7ICYeSTIKh7XiBJ1IeqQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "arm64";
        sha256 = "sha256-cAFf86M2y2EsR0/Wemqj5fleuLIZ32msL+KY5jheJQ0="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "amd64";
        sha256 = "sha256-2expFXpJKBr09A+9HgKBJCfulXBD0Yyyo7vZBOgxhJk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-W0z5VyuRP8reXOQQG6JDOCSKIO8bncKv8tdSVquSHGI="; # aarch64-darwin
      };
    };
  };
}
