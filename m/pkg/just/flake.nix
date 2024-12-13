{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-just"; };

    url_template = input: "https://github.com/casey/just/releases/download/${input.vendor}/just-${input.vendor}-${input.arch}-${input.os}.tar.gz";

    downloads = {
      "x86_64-linux" = {
        os = "unknown-linux-musl";
        arch = "x86_64";
        sha256 = "sha256-yAPmf9ewrwFme9U3GXvD3zGZOOrPno1RpEHHHQMDW7U="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "unknown-linux-musl";
        arch = "aarch64";
        sha256 = "sha256-797TsGJwjCv1Xn1+cgj0ercBNKKZ5m5C0nWfZ7Qh+dM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "apple-darwin";
        arch = "x86_64";
        sha256 = "sha256-e5S9ux5+zJJUwDjeXgswt7wTPMXAXPMLYjbfLC74AiY="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "apple-darwin";
        arch = "aarch64";
        sha256 = "sha256-nzUqS90f+R3FvR2vqqLtyefASi62SxwYJEV4rkX/EWo="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 just $out/bin/just
    '';
  };
}
