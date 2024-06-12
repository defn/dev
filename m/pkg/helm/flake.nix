{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain {
    src = builtins.path { path = ./.; name = "pkg-helm"; };

    url_template = input: "https://get.helm.sh/helm-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */helm $out/bin/helm
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-JpS5HD5QHP9XyvZQ5jlgSidGRfYa8upNYBZ3t0a0T+I="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-rc8HsISEtSUI5cvItfSwsNtQNC97xIfs2IuJSLaA5qc="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-6ZqSZqUyjLV12B7xAkeRH0LZ6Qx2727vFUxcU1VlZYs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-MBQ9q8HanTLH1sWJ+tBLHx7Mc4QTk9WCP6IcXX9b+PY="; # aarch64-darwin
      };
    };
  };
}
