{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-kubeseal"; };

    url_template = input: "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${input.vendor}/kubeseal-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 kubeseal $out/bin/kubeseal
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-9vuu6hhKr5QimHaK1Y4gMp7t5uznqOzNOjglishLe6o="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-knhiSm89IJTrLgpuwGuJMYr+D5u+pS3A/mFCQ+IlzWw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-9cOGwQJWjhrXYNa/id0ZQKiQgKg/Nzd/X1lkR9DtdAg="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-UiO9WOZqMDvQGnE32PEI40wr59aUhvSzGF1sh1HKwvk="; # aarch64-darwin
      };
    };
  };
}
