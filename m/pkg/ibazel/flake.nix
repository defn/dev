{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-ibazel"; };

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
        sha256 = "sha256-Q38cORCoM6GHaiCLNTvjYQjkQp3/jNOYHv5QnwCXlNk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-oqRMO3VqvZQvIdyDnvhQaSHCJVbthaTJ9e7PRbZ1YUM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-gbFw9ZEfr++DfaEK3ay5I9p1kzSwutmy5MwU0GQ9wVw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Sxg2TK8RJ2iWrH97gl63WF5r52/8UROJNbOAh9hQqT4="; # aarch64-darwin
      };
    };
  };
}
