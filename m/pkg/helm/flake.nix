{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
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
        sha256 = "sha256-5X6CZBAmnXK+MRMzPb+qwNjf3RsMxOnLCL35dyJzHKk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-eAtbhvDbVUZ2mz6fAgRxO73S9mlt/arBIvvn8vMVQdI="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-GxlIJONto+OImSCWCpOGi1QceIjJBaBnV+iGZs+1Ysk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-QFo7E/DhlBgPe4QBDf6GaJ13A+gGEnKYgq1x4qTvNQQ="; # aarch64-darwin
      };
    };
  };
}
